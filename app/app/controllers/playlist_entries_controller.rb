class PlaylistEntriesController < ApplicationController
  before_action :set_playlist_entry, only: [:show, :edit, :update, :destroy]

  # GET /playlist_entries
  # GET /playlist_entries.json
  def index
    @playlist_entries = PlaylistEntry.all
  end

  # GET /playlist_entries/1
  # GET /playlist_entries/1.json
  def show
  end

  # GET /playlist_entries/new
  def new
    @playlist_entry = PlaylistEntry.new
  end

  # GET /playlist_entries/1/edit
  def edit
  end

  # POST /playlist_entries
  # POST /playlist_entries.json
  def create
    @playlist_entry = PlaylistEntry.new(playlist_entry_params)

    respond_to do |format|
      if @playlist_entry.save
        format.html { redirect_to @playlist_entry, notice: 'Playlist entry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playlist_entry }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlist_entries/1
  # PATCH/PUT /playlist_entries/1.json
  def update
    respond_to do |format|
      if @playlist_entry.update(playlist_entry_params)
        format.html { redirect_to @playlist_entry, notice: 'Playlist entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_entries/1
  # DELETE /playlist_entries/1.json
  def destroy
    @playlist_entry.destroy
    respond_to do |format|
      format.html { redirect_to playlist_entries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist_entry
      @playlist_entry = PlaylistEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_entry_params
      params.require(:playlist_entry).permit(:start_time, :premiere)
    end
end
