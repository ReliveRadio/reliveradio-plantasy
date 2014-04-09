class PlaylistManagementController < ApplicationController
  before_action :set_channel_playlist
  before_filter :authenticate_admin!

  def index
  	@episodes = Episode.all
  	@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.now}).order(start_time: :asc)
  end

  def create_entry
  	@episode = Episode.find(params[:episode_id])

  	# calc start time for new playlist entry
  	@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.now}).order(start_time: :asc)

  	if @playlist_entries.blank?
  		start_time = Time.now
  	else
  		start_time = @playlist_entries.last.end_time + @episode.duration.seconds
  	end

  	end_time = start_time + @episode.duration.seconds

  	PlaylistEntry.create(channel_playlist_id: @channel_playlist.id, episode_id: @episode.id, start_time: start_time, end_time: end_time)

  	update_mpd @channel_playlist

    respond_to do |format|
      format.html { redirect_to playlist_management_url, channel_playlist: @channel_playlist.id, notice: 'Episode was added to the playlist.' }
    end
  end

  def destroy_entry
  	params[:playlist_entry_id]
  end

  def move_entry
  	
  end






















  private
    def set_channel_playlist
      @channel_playlist = ChannelPlaylist.find(params[:channel_playlist])
    end

    def update_mpd(channel_playlist)
		# collect all future entries
		playlist_entries = channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.now}).order(start_time: :asc)

		mpd = MPD.new
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

		# if status is blank there is nothing in the queue

		# TODO add check if all episodes are cached!
		
		playlist_entries.each do |entry|
			mpd.add File.basename(entry.episode.local_path)
		end		
		mpd.play
		mpd.disconnect
    end

end
