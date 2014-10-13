class DirectoryController < ApplicationController

  def index
    # search all matchin podcasts
    @query = Podcast.search(params[:q])
    @query.sorts = 'title asc' if @query.sorts.empty?
    @podcasts = @query.result

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
