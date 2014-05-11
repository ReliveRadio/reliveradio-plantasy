class ScheduleController < ApplicationController
  before_action :set_channel_playlist, only: [:show]

  def index
  	@channel_playlists = ChannelPlaylist.all
  end

  def show
  	@playlist_entries = @channel_playlist.playlist_entries.where("end_time >= :now", {now: Time.zone.now}).order(:position)
    respond_to do |format|
      format.html { }
      format.js { }
    end
  end

  private
    def set_channel_playlist
      @channel_playlist = ChannelPlaylist.find(params[:channel_playlist_id])
    end
end