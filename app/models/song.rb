class Song < ApplicationRecord
  belongs_to :user
  attr_reader :title, :artist, :spotify_uri

  def initialize(title, artist, spotify_uri)
    super()
    @title = title
    @artist = artist
    @spotify_uri = spotify_uri
  end

  private

  def song_search
    RSpotify::Track.search(artist.name + ' ' + name)
  end
end
