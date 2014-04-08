class PlaylistManagementController < ApplicationController
  before_action :set_channel_playlist
  before_filter :authenticate_admin!

  def index
  	@episodes = Episode.all
  	# TODO
  	# cut off all entries in the past?
  	@playlist_entries = @channel_playlist.playlist_entries.order(start_time: :asc)
  end

  def create_entry
  	@episode = Episode.find(params[:episode_id])
  	@playlist_entries = @channel_playlist.playlist_entries.order(start_time: :asc)

  	# TODO
  	# cut off all entries in the past?

  	if @playlist_entries.blank?
  		start_time = Time.now
  	else
  		start_time = @playlist_entries.last.end_time + @episode.duration.seconds
  	end

  	end_time = start_time + @episode.duration.seconds

  	PlaylistEntry.create(channel_playlist_id: @channel_playlist.id, episode_id: @episode.id, start_time: start_time, end_time: end_time)


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

end
