class SongsController < ApplicationController
  before_action :set_song, only: [:show, :destroy]

  # GET /songs
  def all
    user = User.find_by(id: session[:user_id])
    spotify_user = RSpotify::User.find(user.uid)
    top_tracks = spotify_user.top_tracks(time_range: 'short_term')
    ret = []
    top_tracks.each do |song|
      test_song = Song.new(song.name, song.artists, song.uri)
      ret << test_song
    end
    @songs = ret
  end

  # GET /artists/1/songs
  def index
    @songs = @artist.songs
  end

  # GET /artists/1/songs/1
  def show
  end

  # GET artists/1/songs/new
  def new
    @song = Song.new
  end

  # POST /artists/1/songs
  def create
    @song = @artist.songs.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to artist_song_path(@artist, @song), notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: artist_song_path(@artist, @song) }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1/songs/1
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to artist_songs_path(@artist), notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.find(params[:id])
  end

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def song_params
    params.require(:song).permit(:name)
  end
end
