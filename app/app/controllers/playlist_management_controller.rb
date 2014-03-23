class PlaylistManagementController < ApplicationController
  
  def index
  	@episodes = Episode.all
  	@channel_playlist = ChannelPlaylist.find(params[:channel_playlist])
  	@playlist_entries = @channel_playlist.playlist_entries
  end

end
