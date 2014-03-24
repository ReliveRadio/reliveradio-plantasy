class DirectoryController < ApplicationController

  def index
  	@podcasts = Podcast.all.order(:title)
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
