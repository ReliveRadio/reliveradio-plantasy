class DirectoryController < ApplicationController

  def index

    @query = Podcast.search(params[:q])
    if params[:q]
      # search all matching podcasts
      @query.sorts = 'title asc' if @query.sorts.empty?
      @podcasts = @query.result
    else
      @podcasts = Podcast.all
    end

    # add pagination
    @podcasts = @podcasts.paginate(:per_page => 15, :page => params[:page])

    respond_to do |format|
      format.html {}
      format.js   {}
    end
  end

  def show_podcast
    @podcast = Podcast.find(params[:id])
    respond_to do |format|
      format.html {}
      format.js   {}
    end
  end

end
