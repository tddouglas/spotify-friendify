class Artist < ApplicationRecord
  validates :artist, presence: true
  validates :spotify_uri, presence: true
  attr_reader :artist, :spotify_uri

  def initialize(artist, spotify_uri)
    super()
    @artist = artist
    @spotify_uri = spotify_uri
  end

  def related_artists
    return nil unless valid?
    @artists = artist_search[0].related_artists
    @artists.map(&:name)
  end

  def top_tracks
    return nil unless valid?
    @artists = artist_search[0].top_tracks(:US)
    @artists.map { |artist| artist.name.split(' (')[0] }
  end

  private

  def artist_search
    RSpotify::Artist.search(name)
  end
end
