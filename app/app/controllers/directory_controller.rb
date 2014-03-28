class DirectoryController < ApplicationController

  def index
    @query = Podcast.search(params[:q])
    @query.sorts = 'title asc' if @query.sorts.empty?
    podcasts = @query.result

    episodes_query = Episode.search(params[:q])
    episodes_query.sorts = 'title asc' if @query.sorts.empty?
    episodes = episodes_query.result

    @results = []
    podcasts.each do |podcast|
      @results.append(PodcastEpisodeWrapper.new(podcast))
    end
    episodes.each do |episode|
      @results.append(PodcastEpisodeWrapper.new(episode))
    end

    # add pagination
    @results = @results.paginate(:per_page => 15, :page => params[:page])

    respond_to do |format|
      format.html {}
      format.js   {}
    end
  end

  def show_podcast
    @podcast = Podcast.find(params[:id])
    @episodes_query = Episode.search(params[:q])
    if params[:q]
      # add podcast id to query to search only in this podcasts episodes
      params[:q].merge!(:podcast_id_eq => @podcast.id)
      @episodes_query = Episode.search(params[:q])
      # sort episodes by pub_date but only if there is no sorts set from the view
      @episodes_query.sorts = 'pub_date desc' if @episodes_query.sorts.empty?
    	@episodes = @episodes_query.result.paginate(:per_page => 15, :page => params[:episodes_page])
    else
      @episodes = @podcast.episodes.order(pub_date: :desc).paginate(:per_page => 15, :page => params[:episodes_page])
    end
    respond_to do |format|
      format.html {}
      format.js   {}
    end
  end

  def show_episode
    @episode = Episode.find(params[:id])
    @podcast = @episode.podcast
  end

end
