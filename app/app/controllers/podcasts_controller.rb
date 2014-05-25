require 'feedjira'

class PodcastsController < ApplicationController
  before_action :set_podcast, only: [:show, :edit, :update, :destroy, :update_feed, :delete_all_episodes, :download_all_episodes]
  before_filter :authenticate_admin!

  # GET /podcasts
  # GET /podcasts.json
  def index
    @query = Podcast.search(params[:q])
    @query.sorts = 'title asc' if @query.sorts.empty?
    @podcasts = @query.result.paginate(:page => params[:page], :per_page => 15)
  end

  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
    @query = Episode.where(podcast_id: @podcast.id).search(params[:q])
    if params[:q]
      @query.sorts = 'pub_date desc' if @query.sorts.empty?
      @episodes = @query.result.paginate(:page => params[:page], :per_page => 15)
    else
      @episodes = @podcast.episodes.order(pub_date: :desc).paginate(:page => params[:page], :per_page => 15)
    end
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
        format.html { redirect_to @podcast, flash: { notice: 'Episodes will be refreshed in background.' }}
    end
  end

  def update_all_feeds
    UpdateAllFeedsWorker.perform_async

    respond_to do |format|
      format.html { redirect_to podcasts_url, flash: { notice: 'All podcast feeds will be refreshed in the background.' }}
    end
  end

  def download_all_episodes
    DownloadAllEpisodesWorker.perform_async(@podcast.id)

    respond_to do |format|
      format.html { redirect_to @podcast, flash: { notice: 'All episodes of this podcast will be downloaded in the background.'} }
    end
  end

  # POST /podcasts
  # POST /podcasts.json
  def create
    feed_url = podcast_params['feed']
  	if !feed_url.blank?
      if !Podcast.exists? feed: feed_url
    	  NewFeedWorker.perform_async(feed_url)
    	  respond_to do |format|
    	    	format.html { redirect_to podcasts_url, flash: { notice: 'Podcast will be added in the background.' }}
    	  end
      else
        @podcast = Podcast.find_by feed: feed_url
        respond_to do |format|
            format.html { redirect_to @podcast, flash: { notice: 'Podcast already in databse.' }}
        end
      end
    else
      respond_to do |format|
    	  format.html { redirect_to new_podcast_url, flash: {error: 'Invalid URL.'} }
    	end 
    end
  end

  # PATCH/PUT /podcasts/1
  # PATCH/PUT /podcasts/1.json
  def update
    respond_to do |format|
      if @podcast.update(podcast_params)
        format.html { redirect_to @podcast, flash: { notice: 'Podcast was successfully updated.' }}
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
      format.html { redirect_to @podcast, flash: { notice: 'All episodes of this podcast have been deleted.' }}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:title, :description, :logo_url, :website, :feed, :tags, :category, :author, :subtitle, :language)
    end
end
