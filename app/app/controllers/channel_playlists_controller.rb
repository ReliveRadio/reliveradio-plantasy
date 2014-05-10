class ChannelPlaylistsController < ApplicationController
  before_action :set_channel_playlist, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_admin!

  # GET /channel_playlists
  # GET /channel_playlists.json
  def index
    @channel_playlists = ChannelPlaylist.all
  end

  # GET /channel_playlists/new
  def new
    @channel_playlist = ChannelPlaylist.new
  end

  # GET /channel_playlists/1/edit
  def edit
  end

  # POST /channel_playlists
  # POST /channel_playlists.json
  def create
    @channel_playlist = ChannelPlaylist.new(channel_playlist_params)

    respond_to do |format|
      if @channel_playlist.save
        format.html { redirect_to @channel_playlist, notice: 'Channel playlist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @channel_playlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @channel_playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channel_playlists/1
  # PATCH/PUT /channel_playlists/1.json
  def update
    respond_to do |format|
      if @channel_playlist.update(channel_playlist_params)
        format.html { redirect_to @channel_playlist, notice: 'Channel playlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @channel_playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_playlists/1
  # DELETE /channel_playlists/1.json
  def destroy
    @channel_playlist.destroy
    respond_to do |format|
      format.html { redirect_to channel_playlists_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_playlist
      @channel_playlist = ChannelPlaylist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def channel_playlist_params
      params.require(:channel_playlist).permit(:author, :name, :description, :language, :stream_url, :mpd_socket_path)
    end
end
