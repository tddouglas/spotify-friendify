require 'rails_helper'

RSpec.feature "Artists", type: :feature do
  describe 'index' do
    let!(:chance) { Artist.create(name: 'Chance The Rapper') }
    let!(:drake) { Artist.create(name: 'Drake') }
    before :each { visit '/artists' }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'lists each artist\'s name as a link' do
      expect(page).to have_link(chance.name, href: "/artists/#{chance.id}")
      expect(page).to have_link(drake.name, href: "/artists/#{drake.id}")
    end

    it 'has a link to each artist\'s related artists page' do
      expect(page).to have_link('Related Artists', href: "/artists/#{chance.id}/related_artists")
      expect(page).to have_link('Related Artists', href: "/artists/#{drake.id}/related_artists")
    end

    it 'has a link to each artist\'s top tracks page' do
      expect(page).to have_link('Top Tracks', href: "/artists/#{chance.id}/top_tracks")
      expect(page).to have_link('Top Tracks', href: "/artists/#{drake.id}/top_tracks")
    end

    it 'has a link to destroy each artist' do
      expect(page).to have_link('Destroy', href: "/artists/#{chance.id}")
      expect(page).to have_link('Destroy', href: "/artists/#{drake.id}")
    end

    scenario 'clicking the destroy button destroys the artist' do
      expect { click_link('Destroy', href: "/artists/#{chance.id}") }.to change { Artist.count }.by(-1)
    end
  end

  describe 'new' do
    before :each { visit '/artists/new' }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'has a text box for artist name' do
      expect(page).to have_field('artist_name')
    end

    it 'has three text boxes for song names' do
      expect(page).to have_field('artist_songs_attributes_0_name')
      expect(page).to have_field('artist_songs_attributes_1_name')
      expect(page).to have_field('artist_songs_attributes_2_name')
    end

    it 'does not create an artist with empty name' do
      expect { click_button('Create Artist') }.to change { Artist.count }.by(0)
    end

    it 'does not create an artist with invalid name' do
      fill_in('artist_name', with: 'Invalid Artist')
      expect { click_button('Create Artist') }.to change { Artist.count }.by(0)
    end

    it 'creates an artist with valid name and no songs' do
      fill_in('artist_name', with: 'Chance The Rapper')
      expect { click_button('Create Artist') }.to change { Artist.count }.by(1)
    end

    it 'does not create a duplicate artist' do
      Artist.create(name: 'Chance The Rapper')
      visit '/artists/new'
      fill_in('artist_name', with: 'Chance The Rapper')
      expect { click_button('Create Artist') }.to change { Artist.count }.by(0)
    end

    it 'does not create an artist with valid name but invalid song' do
      fill_in('artist_name', with: 'Chance The Rapper')
      fill_in('artist_songs_attributes_0_name', with: 'Invalid Song')
      expect { click_button('Create Artist') }.to change { Artist.count }.by(0)
    end

    it 'creates an artist with valid name and valid songs' do
      fill_in('artist_name', with: 'Chance The Rapper')
      fill_in('artist_songs_attributes_0_name', with: 'Angels')
      fill_in('artist_songs_attributes_1_name', with: 'Blessings')
      expect { click_button('Create Artist') }.to change { Artist.count }.by(1)
      expect(Artist.find_by(name: 'Chance The Rapper').songs.count).to eq(2)
    end
  end

  describe 'show' do
    let!(:chance) { Artist.create(name: 'Chance The Rapper') }
    let!(:chance_angels) { chance.songs.create(name: 'Angels') }
    let!(:chance_blessings) { chance.songs.create(name: 'Blessings') }
    before :each { visit "/artists/#{chance.id}" }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'displays the artist\'s name' do
      expect(page).to have_text(chance.name)
    end

    it 'displays the names of the artist\'s songs as links' do
      expect(page).to have_link(chance_angels.name, href: "/artists/#{chance.id}/songs/#{chance_angels.id}")
      expect(page).to have_link(chance_blessings.name, href: "/artists/#{chance.id}/songs/#{chance_blessings.id}")
    end

    it 'displays an iframe for each song' do
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{chance_angels.spotify_uri}']")
      expect(page).to have_css("iframe[src*='https://open.spotify.com/embed?uri=#{chance_blessings.spotify_uri}']")
    end
  end

  describe 'related_artists' do
    let!(:lupe) { Artist.create(name: 'Lupe Fiasco') }
    let!(:chance) { Artist.create(name: 'Chance The Rapper') }
    before :each { visit "/artists/#{chance.id}/related_artists" }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'displays a link to the artist\'s show page' do
      expect(page).to have_link(chance.name, href: "/artists/#{chance.id}")
    end

    it 'displays the name of the 20 artists related to the current artist' do
      related_artists = ['Vic Mensa', 'Isaiah Rashad', 'Ab-Soul', 'Mick Jenkins', 'Mac Miller', 'Earl Sweatshirt', 'Lupe Fiasco', 'Frank Ocean', 'A$AP Rocky', 'Joey Bada$$', 'Donnie Trumpet & The Social Experiment', 'Vince Staples', 'Domo Genesis', 'Tyler, The Creator', 'BJ The Chicago Kid', 'Pusha T', 'Alex Wiley', 'GoldLink', 'J. Cole', 'Kanye West']
      related_artists.each { |artist| expect(page).to have_text(artist) }
    end

    it 'displays a Create Artist button next to every artist that does not exist' do
      expect(page).to have_button('Create Artist', count: 19)
    end

    it 'displays a View Artist link next to every artist that does exist' do
      expect(page).to have_link('View Artist', count: 1)
    end
  end

  describe 'top_tracks' do
    let!(:chance) { Artist.create(name: 'Chance The Rapper') }
    let!(:chance_angels) { chance.songs.create(name: 'Angels') }
    let!(:chance_blessings) { chance.songs.create(name: 'Blessings') }
    before :each { visit "/artists/#{chance.id}/top_tracks" }

    it 'loads the page successfully' do
      expect(status_code).to eq(200)
    end

    it 'displays a link with the artist\'s name' do
      expect(page).to have_link(chance.name, href: "/artists/#{chance.id}")
    end

    it 'displays the name of the 10 top trakcs of the current artist' do
      top_tracks = ['No Problem', 'Juke Jam', 'All Night', 'Same Drugs', 'All We Got', 'Smoke Break', 'Angels', 'Summer Friends', 'Blessings', 'Mixtape']
      top_tracks.each { |track| expect(page).to have_text(track) }
    end

    it 'displays a Create Song button next to each track that does not exist' do
      expect(page).to have_button('Create Song', count: 8)
    end

    it 'displays a View Song link next to every track that does exist' do
      expect(page).to have_link('View Song', count: 2)
    end
  end
end
