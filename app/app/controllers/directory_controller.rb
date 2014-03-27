class DirectoryController < ApplicationController

  def index
    @podcasts = Podcast.search(params[:search]).order(:title).paginate(:per_page => 15, :page => params[:page])
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
