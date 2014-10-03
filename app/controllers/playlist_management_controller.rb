class PlaylistManagementController < ApplicationController
	before_action :set_channel_playlist
	before_filter :authenticate_admin!

	def index
		@query = Episode.search(params[:q])
		@query.sorts = 'title asc' if @query.sorts.empty? # sort by title asc default. otherwise sorts is already set by form
		@episodes = @query.result.paginate(:per_page => 15, :page => params[:page])

		@jingles = Jingle.all

		fetch_playlist_entries_and_offset
		respond_to do |format|
			format.js { render 'search' }
			format.html {}
		end
	end

	def update_playlist
		fetch_playlist_entries_and_offset
		respond_to do |format|
			format.js { render 'playlist_update' }
		end
	end

	def append_entry
		if params[:jingle_id]
			@jingle = Jingle.find(params[:jingle_id])
		elsif params[:episode_id]
			@episode = Episode.find(params[:episode_id])
		end

		# only create new playlist entry if episode is cached. jingles are always cached
		if ((@episode && @episode.cached?) || @jingle)
			# calc start time for new playlist entry
			@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.zone.now}).order(:position)

			if @playlist_entries.blank?
				start_time = Time.zone.now
			else
				start_time = @playlist_entries.last.end_time
			end

			if @jingle
				end_time = start_time + @jingle.duration.seconds
				@playlist_entry = PlaylistEntry.create(channel_playlist: @channel_playlist, jingle: @jingle, start_time: start_time, end_time: end_time)
			elsif @episode
				end_time = start_time + @episode.duration.seconds
				@playlist_entry = PlaylistEntry.create(channel_playlist: @channel_playlist, episode: @episode, start_time: start_time, end_time: end_time)
			end

			update_mpd @channel_playlist
		end

		# update playlist html element via JS response
		fetch_playlist_entries_and_offset
		respond_to do |format|
			format.js { render 'playlist_update'}
		end    
	end

	def destroy_entry
		@playlist_entry = PlaylistEntry.find(params[:playlist_entry_id])
		# do not remove just playling entry
		# ensure buffer: end_time > Time.zone.now + 30.minutes
		if (!@playlist_entry.blank? && !@playlist_entry.isInDangerZone?)
			# adjust all start and end times of all episodes after the entry
			# start time for the entry AFTER the deleted one has to be end time of the entry BEFORE the deleted one
			temp_start_time = @playlist_entry.higher_item.end_time
			# update all after entries play times
			@playlist_entry.lower_items.each do |entry|
				entry.start_time = temp_start_time
				entry.end_time = temp_start_time + entry.episode.duration.seconds if entry.is_episode?
				entry.end_time = temp_start_time + entry.jingle.duration.seconds if entry.is_jingle?
				entry.save
				temp_start_time = entry.end_time
			end
			# remove entry
			@playlist_entry.remove_from_list
			@playlist_entry.destroy
			# update mpd
			update_mpd @channel_playlist
		end
		# update playlist html element via JS response
		fetch_playlist_entries_and_offset

		respond_to do |format|
			format.js { render 'playlist_update' }
		end
	end

	# posts a list of entries.
	# their index in the list is their new position
	# their id in the list is the playlist entry id
	# offset parameter is the position of the first playlist entry returned by index action
	# danger zone: end_time < Time.zone.now + 30.minutes
	def sort
		offset = params[:offset].to_i # position of the first entry in the list that was rendered in the view

		# check if changes were made in danger zone
		save_change = true;
		params[:playlist_entry].each_with_index do |id, index|
			position = index + offset
			entry = PlaylistEntry.find(id)
			# check if entry was swapped to new position
			if entry.position != position
				if entry.isInDangerZone?
					save_change = false
					break
				end
			end
		end

		if save_change
			# update positions and start and end times
			# start time of the first entry in the new changeable entries list ist the end_time of the playlist entry before
			# there always is an playlist entry before, because otherwise save_change would be false
			temp_start_time = PlaylistEntry.where(position: offset - 1).first.end_time
			params[:playlist_entry].each_with_index do |id, index|
				entry = PlaylistEntry.find(id)
				entry.position = index + offset
				entry.start_time = temp_start_time
				entry.end_time = temp_start_time + entry.episode.duration.seconds if entry.is_episode?
				entry.end_time = temp_start_time + entry.jingle.duration.seconds if entry.is_jingle?
				entry.save
				temp_start_time = entry.end_time
			end

			# update mpd
			update_mpd @channel_playlist
		end

		# update playlist html element via JS response
		fetch_playlist_entries_and_offset
		respond_to do |format|
			format.js { render 'playlist_update' }
		end
	end

	# forces complete clear of mpd playlist and refill it with current database playlist status
	# this will break the stream as mpd will stop playling for some time!
	def reset_mpd
		mpd = MPD.new @channel_playlist.mpd_socket_path
		mpd.connect
		mpd.stop
		mpd.disconnect
		update_mpd @channel_playlist
	end






















	private
		def set_channel_playlist
			@channel_playlist = ChannelPlaylist.find(params[:channel_playlist_id])
		end

		def fetch_playlist_entries_and_offset
			@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.zone.now}).order(:position)

			@immutable_entries = Array.new @playlist_entries
			@immutable_entries.delete_if {|entry| !entry.isInDangerZone? }

			@changeable_entries = Array.new @playlist_entries
			@changeable_entries.delete_if {|entry| entry.isInDangerZone? }

			if @changeable_entries.blank?
				@offset = 1 # does not matter because of changeable entries are blank, nothing can be resorted
			else
				@offset = @changeable_entries.first.position
			end
		end

		def update_mpd(channel_playlist)
			# collect all future entries
			playlist_entries = channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.zone.now}).order(start_time: :asc)


			mpd = MPD.new channel_playlist.mpd_socket_path
			mpd.connect

			# delete all mpd entries but not the currently playling one
			status = mpd.status
			if status[:playlistlength] > 0 && status[:state] == :play
				# remove live entry
				playlist_entries.delete_if { |entry| entry.is_live? }

				# delete all played entries
				if status[:song] > 0
					mpd.delete 0...status[:song]
				end
				# update status because positions changed
				status = mpd.status
				# delete all future entries
				start = status[:song] + 1
				if start < status[:playlistlength]
					mpd.delete start...status[:playlistlength]
				end
			else
				mpd.clear if status[:state] == :stop
				seek = true
			end

			# add remaining entries to the mpd playlist
			playlist_entries.each do |entry|

				mpd.add "file://" + File.join(Rails.root, 'public', entry.episode.audio.path) if entry.is_episode?
				mpd.add "file://" + File.join(Rails.root, 'public', entry.jingle.audio.path) if entry.is_jingle?

				# seek the live entry to the correct position
				if seek && entry.is_live?
					options = {pos: 0}
					time_to_seek = (Time.zone.now - entry.start_time).round
					mpd.seek(time_to_seek, options)
				end
			end

			mpd.play # ensure mpd is playing
			mpd.disconnect
		end

end
