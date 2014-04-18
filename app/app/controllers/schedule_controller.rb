class ScheduleController < ApplicationController
  before_action :set_channel_playlist, only: [:show]

  def index
  	@channel_playlists = ChannelPlaylist.all
  end

  def show
  	@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.now}).order(:position)
  end

  private
    def set_channel_playlist
      @channel_playlist = ChannelPlaylist.find(params[:channel_playlist])
    end
end