require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe 'associations' do
    let!(:chance) { Artist.create(name: 'Chance The Rapper') }

    it 'has_many songs' do
      blessings = Song.create(artist: chance, name: 'Blessings')
      angels = chance.songs.create(name: 'Angels')
      expect(chance.songs).to match_array([angels, blessings])
    end

    it 'accepts_nested_attributes_for songs' do
      expect { Artist.create(name: 'Drake', songs_attributes: { 0 => { name: 'Blessings' } }) }.to change { Song.count }.by(1)
    end

    it 'rejects songs_attributes if all blank' do
      expect { Artist.create(name: 'Drake', songs_attributes: {}) }.to change { Song.count }.by(0)
    end
  end

  describe 'validations' do
    it 'validates presence of name' do
      expect(Artist.new.valid?).to be(false)
    end

    it 'validates uniqueness of name' do
      Artist.create(name: 'Chance The Rapper')
      expect(Artist.new(name: 'Chance The Rapper').valid?).to be(false)
    end

    it 'validates that the user is in Spotify' do
      expect(Artist.new(name: 'Invalid Artist').valid?).to be(false)
    end
  end 

  describe '#related_artists' do
    it 'returns nil if the artist isn\'t valid' do
      expect(Artist.new(name: 'Invalid Artist').related_artists).to be nil
    end

    it 'returns an array containing the names of 20 related artists' do
      expect(Artist.create(name: 'Chance The Rapper').related_artists).to match_array(['Vic Mensa', 'Isaiah Rashad', 'Ab-Soul', 'Mick Jenkins', 'Mac Miller', 'Earl Sweatshirt', 'Lupe Fiasco', 'Frank Ocean', 'A$AP Rocky', 'Joey Bada$$', 'Donnie Trumpet & The Social Experiment', 'Vince Staples', 'Domo Genesis', 'Tyler, The Creator', 'BJ The Chicago Kid', 'Pusha T', 'Alex Wiley', 'GoldLink', 'J. Cole', 'Kanye West'])
    end
  end

  describe '#top_tracks' do
    it 'returns nil if the artist isn\'t valid' do
      expect(Artist.new(name: 'Invalid Artist').related_artists).to be nil
    end

    it 'returns an array containing the names of 10 top tracks' do
      expect(Artist.create(name: 'Chance The Rapper').top_tracks).to match_array(['No Problem', 'Juke Jam', 'All Night', 'Same Drugs', 'All We Got', 'Smoke Break', 'Angels', 'Summer Friends', 'Blessings', 'Mixtape'])
    end
  end
end
