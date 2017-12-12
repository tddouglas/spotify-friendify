require 'rails_helper'

RSpec.feature "Songs", type: :feature do
  let!(:chance) { Artist.create(name: 'Chance The Rapper') }
  let!(:drake) { Artist.create(name: 'Drake') }

  describe 'all' do
    let!(:chance_angels) { chance.songs.create(name: 'Angels') }
    let!(:chance_blessings) { chance.songs.create(name: 'Blessings') }
    let!(:drake_blessings) { drake.songs.create(name: 'Blessings') }
    before :each { visit '/songs' }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'lists each song with its artist' do
      expect(page).to have_text("#{chance_angels.name} by #{chance_angels.artist.name}")
      expect(page).to have_text("#{chance_blessings.name} by #{chance_blessings.artist.name}")
      expect(page).to have_text("#{drake_blessings.name} by #{drake_blessings.artist.name}")
    end

    it 'lists each artist\'s name as a link' do
      expect(page).to have_link(chance.name, href: "/artists/#{chance.id}", count: 2)
      expect(page).to have_link(drake.name, href: "/artists/#{drake.id}", count: 1)
    end

    it 'lists each song\'s name as a link' do
      expect(page).to have_link(chance_angels.name, href: "/artists/#{chance_angels.artist.id}/songs/#{chance_angels.id}")
      expect(page).to have_link(chance_blessings.name, href: "/artists/#{chance_blessings.artist.id}/songs/#{chance_blessings.id}")
      expect(page).to have_link(drake_blessings.name, href: "/artists/#{drake_blessings.artist.id}/songs/#{drake_blessings.id}")
    end

    it 'has an iframe for each song' do
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{chance_angels.spotify_uri}']")
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{chance_blessings.spotify_uri}']")
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{drake_blessings.spotify_uri}']")
    end
  end

  describe 'index' do
    let!(:chance_angels) { chance.songs.create(name: 'Angels') }
    let!(:chance_blessings) { chance.songs.create(name: 'Blessings') }
    let!(:drake_blessings) { drake.songs.create(name: 'Blessings') }
    before :each { visit "/artists/#{chance.id}/songs" }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'displays the artist\'s name as a link' do
      expect(page).to have_link(chance.name, href: "/artists/#{chance.id}")
    end

    it 'lists all of the artist\'s song names as a link' do
      expect(page).to have_link(chance_angels.name, href: "/artists/#{chance_angels.artist.id}/songs/#{chance_angels.id}")
      expect(page).to have_link(chance_blessings.name, href: "/artists/#{chance_blessings.artist.id}/songs/#{chance_blessings.id}")
      expect(page).to_not have_link(drake_blessings.name, href: "/artists/#{drake_blessings.artist.id}/songs/#{drake_blessings.id}")
    end

    it 'displays iframes for each song' do
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{chance_angels.spotify_uri}']")
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{chance_blessings.spotify_uri}']")
      expect(page).to_not have_css("iframe[src*='https://open.spotify.com/embed?uri=#{drake_blessings.spotify_uri}']")
    end
  end

  describe 'show' do
    let!(:chance_angels) { chance.songs.create(name: 'Angels') }
    before :each { visit "/artists/#{chance_angels.artist.id}/songs/#{chance_angels.id}" }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'displays the song name and artist name' do
      expect(page).to have_text("#{chance_angels.name} by #{chance_angels.artist.name}")
    end

    it 'has a link to the artist' do
      expect(page).to have_link(chance_angels.artist.name, href: "/artists/#{chance_angels.artist.id}")
    end

    it 'displays an iframe' do
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{chance_angels.spotify_uri}']")
    end

    it 'has a link to delete the song' do
      expect(page).to have_link('Delete', href: "/artists/#{chance_angels.artist.id}/songs/#{chance_angels.id}")
    end

    scenario 'clicking the delete link deletes the song' do
      expect { click_link('Delete') }.to change { Song.count }.by(-1)
    end
  end

  describe 'new' do
    before :each { visit "/artists/#{chance.id}/songs/new" }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'displays the artist\'s name as a link' do
      expect(page).to have_link(chance.name, href: "/artists/#{chance.id}")
    end

    it 'displays a field for the name' do
      expect(page).to have_field('song_name')
    end

    it 'does not create a song without a name' do
      expect { click_button('Create Song') }.to change { Song.count }.by(0)
    end

    it 'does not create a song with an invalid name' do
      fill_in('song_name', with: 'Invalid Song')
      expect { click_button('Create Song') }.to change { Song.count }.by(0)
    end

    it 'does create a song with a valid name' do
      fill_in('song_name', with: 'Angels')
      expect { click_button('Create Song') }.to change { Song.count }.by(1)
    end
  end
end
