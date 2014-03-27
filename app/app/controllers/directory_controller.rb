class DirectoryController < ApplicationController

  def index
    @podcast_query = Podcast.search(params[:q])
    @podcast_query.sorts = 'title asc' if @podcast_query.sorts.empty?
    @podcasts = @podcast_query.result.paginate(:per_page => 15, :page => params[:podcasts_page])
    respond_to do |format|
      format.html {}
      format.js   {}
    end
  end

  def show_podcast
    @podcast = Podcast.find(params[:id])
  	@episodes = @podcast.episodes.order(:pub_date).reverse
  end

  def show_episode
    @episode = Episode.find(params[:id])
    @podcast = @episode.podcast
  end

end
