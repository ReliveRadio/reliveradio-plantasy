require 'feedjira'

class PodcastsController < ApplicationController
  before_action :set_podcast, only: [:show, :edit, :update, :destroy, :update_feed, :delete_all_episodes, :download_all_episodes]

  # GET /podcasts
  # GET /podcasts.json
  def index
    @podcasts = Podcast.all
  end

  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
    @episodes = @podcast.episodes.order(:pub_date).reverse
  end

  # GET /podcasts/new
  def new
    @podcast = Podcast.new
  end

  # GET /podcasts/1/edit
  def edit
  end

  def update_feed
    # reload episodes in the background with sidekiq
    UpdateFeedWorker.perform_async(@podcast.id)

    respond_to do |format|
        format.html { redirect_to @podcast, notice: 'Episodes will be refreshed in background.' }
    end
  end

  def update_all_feeds
    UpdateAllFeedsWorker.perform_async

    respond_to do |format|
      format.html { redirect_to podcasts_url, notice: 'All podcast feeds will be refreshed in the background.' }
    end
  end

  def download_all_episodes
    DownloadAllEpisodesWorker.perform_async(@podcast.id)

    respond_to do |format|
      format.html { redirect_to @podcast, notice: 'All episodes of this podcast will be downloaded in the background.' }
    end
  end

  # POST /podcasts
  # POST /podcasts.json
  def create
    NewFeedWorker.perform_async(podcast_params['feed'])

    respond_to do |format|
      format.html { redirect_to podcasts_url, notice: 'Podcast will be added in the background.' }
    end
  end

  # PATCH/PUT /podcasts/1
  # PATCH/PUT /podcasts/1.json
  def update
    respond_to do |format|
      if @podcast.update(podcast_params)
        format.html { redirect_to @podcast, notice: 'Podcast was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @podcast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /podcasts/1
  # DELETE /podcasts/1.json
  def destroy
    @podcast.destroy
    # TODO delete all cached audio files
    respond_to do |format|
      format.html { redirect_to podcasts_url }
      format.json { head :no_content }
    end
  end

  def delete_all_episodes
    @podcast.episodes.each do |episode|
      episode.destroy
    end
    respond_to do |format|
      format.html { redirect_to @podcast, notice: 'All episodes of this podcast have been deleted.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:title, :description, :logo_url, :website, :feed, :tags, :category)
    end
end
