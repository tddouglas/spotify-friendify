require 'rails_helper'

RSpec.describe Song, type: :model do
  let!(:chance) { Artist.create(name: 'Chance The Rapper') }
  let!(:drake) { Artist.create(name: 'Drake') }

  describe 'associations' do
    it 'belongs to an artist' do
      angels = Song.new(artist: chance, name: 'Angels')
      expect(angels.artist).to eq(chance)
    end
  end

  describe 'validations' do
    it 'validates the presence of the name' do
      expect(Song.new.valid?).to be(false)
    end

    it 'validates the uniqueness of the name in the scope of the artist' do
      drake.songs.create(name: 'Blessings')
      expect { chance.songs.create(name: 'Blessings') }.to change { Song.count }.by(1)
      expect(chance.songs.new(name: 'Blessings').valid?).to be(false)
    end

    it 'validates that the song is in spotify' do
      expect(Song.new(name: 'Invalid Song', artist: chance).valid?).to be(false)
    end
  end

  describe '#spotify_uri' do
    it 'returns nil if the song is not valid' do
      expect(chance.songs.new(name: 'Invalid Song').spotify_uri).to be(nil)
    end

    it 'returns the song\'s uri if valid' do
      expect(chance.songs.create(name: 'Angels').spotify_uri).to eq('spotify:track:0jx8zY5JQsS4YEQcfkoc5C')
    end
  end
end
