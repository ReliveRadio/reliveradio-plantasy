require 'ruby-mpd'

class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show, :edit, :update, :destroy, :download, :play, :delete_cached_file]
  before_filter :authenticate_admin!

  # GET /episodes
  # GET /episodes.json
  def index
    @episodes = Episode.all
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show
  end

  # GET /episodes/new
  def new
    @episode = Episode.new
  end

  # GET /episodes/1/edit
  def edit
  end

  def download
    DownloadEpisodeWorker.perform_async(@episode.id)
    respond_to do |format|
      format.html { redirect_to @episode, notice: 'File will be downloaded in background.'}
      format.js { render :nothing => true, :status => 200}
    end
  end

  # POST /episodes
  # POST /episodes.json
  def create
    @episode = Episode.new(episode_params)

    respond_to do |format|
      if @episode.save
        format.html { redirect_to @episode, notice: 'Episode was successfully created.' }
        format.json { render action: 'show', status: :created, location: @episode }
      else
        format.html { render action: 'new' }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    respond_to do |format|
      if @episode.update(episode_params)
        format.html { redirect_to @episode, notice: 'Episode was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_cached_file
    if @episode.cached?
      @episode.remove_cache
      respond_to do |format|
        format.html { redirect_to @episode, flash: {notice: 'File was deleted.'}}
      end
    else
      respond_to do |format|
        format.html { redirect_to @episode, flash: {error: 'Can not delete cached file as it is not cached.'}}
      end
    end
  end

  # DELETE /episodes/1
  # DELETE /episodes/1.json
  def destroy
    @episode.destroy
    respond_to do |format|
      format.html { redirect_to episodes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:title, :link, :pub_date, :guid, :subtitle, :content, :duration, :flattr_url, :tags, :icon_url, :audio_file_url, :cached, :local_path)
    end
end
