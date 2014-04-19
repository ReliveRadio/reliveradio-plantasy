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

		# calc start time for new playlist entry
		@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.now}).order(:position)

		if @playlist_entries.blank?
			start_time = Time.now
		else
			start_time = @playlist_entries.last.end_time
		end

		if @jingle
			end_time = start_time + @jingle.duration.seconds
			PlaylistEntry.create(channel_playlist: @channel_playlist, jingle: @jingle, start_time: start_time, end_time: end_time)
		elsif @episode
			end_time = start_time + @episode.duration.seconds
			PlaylistEntry.create(channel_playlist: @channel_playlist, episode: @episode, start_time: start_time, end_time: end_time)
		end

		update_mpd @channel_playlist

		# update playlist html element via JS response
		fetch_playlist_entries_and_offset
		respond_to do |format|
			format.js { render 'playlist_update' }
		end    
	end

	def destroy_entry
		@playlist_entry = PlaylistEntry.find(params[:playlist_entry_id])
		# do not remove just playling entry
		if !@playlist_entry.blank? && !@playlist_entry.isLive?
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
	def sort
		offset = params[:offset].to_i # position of the first entry in the list that was rendered in the view
		params[:playlist_entry].each_with_index do |id, index|
			PlaylistEntry.where(id: id).update_all(position: index + offset)
		end

		# update start and end times
		temp_start_time = PlaylistEntry.find(params[:playlist_entry][0]).start_time
		params[:playlist_entry].each do |id|
			entry = PlaylistEntry.find(id)
			entry.start_time = temp_start_time
			entry.end_time = temp_start_time + entry.episode.duration.seconds if entry.is_episode?
			entry.end_time = temp_start_time + entry.jingle.duration.seconds if entry.is_jingle?
			entry.save
			temp_start_time = entry.end_time
		end

		# update mpd
		update_mpd @channel_playlist

		# update playlist html element via JS response
		fetch_playlist_entries_and_offset
		respond_to do |format|
			format.js { render 'playlist_update' }
		end
	end






















	private
		def set_channel_playlist
			@channel_playlist = ChannelPlaylist.find(params[:channel_playlist])
		end

		def fetch_playlist_entries_and_offset
			@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.now}).order(:position)
			if @playlist_entries.blank?
				@offset = 1
			else
				@offset = @playlist_entries.first.position
			end
		end

		def update_mpd(channel_playlist)
		# collect all future entries
		playlist_entries = channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.now}).order(start_time: :asc)


		mpd = MPD.new channel_playlist.mpd_socket_path
		mpd.connect

		# delete all mpd entries but not the currently playling one
		status = mpd.status
		if status[:playlistlength] > 0 && status[:state] == :play
			# remove live entry
			playlist_entries.delete_if { |entry| entry.isLive? }

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
			#TODO seek!!!
		end

		# add remaining entries to the mpd playlist		
		playlist_entries.each do |entry|
			mpd.add "file://" + entry.episode.local_path if entry.is_episode?
			mpd.add "file://" + entry.jingle.audio_url if entry.is_jingle?
		end		
		mpd.play # ensure mpd is playing
		mpd.disconnect
	end

end
