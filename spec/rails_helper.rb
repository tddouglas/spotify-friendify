# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migrator.migrate(File.join(Rails.root, 'db/migrate'))

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:each) do
    # RSpotify::Artist Mocks
    artist_drake = double(RSpotify::Artist, name: 'Drake')
    allow(artist_drake).to receive(:top_tracks).with(:US) do
      [double(RSpotify::Track, name: 'One Dance'), double(RSpotify::Track, name: 'Passionfruit'), double(RSpotify::Track, name: 'Signs'), double(RSpotify::Track, name: 'Portland'), double(RSpotify::Track, name: 'Fake Love'), double(RSpotify::Track, name: 'Gyalchester'), double(RSpotify::Track, name: 'Do Not Disturb'), double(RSpotify::Track, name: 'Jumpman'), double(RSpotify::Track, name: 'Teenage Fever'), double(RSpotify::Track, name: 'Too Good')] 
    end
    allow(artist_drake).to receive(:related_artists) do
      [double(RSpotify::Artist, name: 'The Weeknd'), double(RSpotify::Artist, name: 'Kendrick Lamar'), double(RSpotify::Artist, name: 'Future'), double(RSpotify::Artist, name: 'G-Eazy'), double(RSpotify::Artist, name: 'Frank Ocean'), double(RSpotify::Artist, name: 'Wiz Khalifa'), double(RSpotify::Artist, name: 'J. Cole'), double(RSpotify::Artist, name: 'Jhene Aiko'), double(RSpotify::Artist, name: 'Kid Cudi'), double(RSpotify::Artist, name: 'Miguel'), double(RSpotify::Artist, name: 'Big Sean'), double(RSpotify::Artist, name: 'B.o.B'), double(RSpotify::Artist, name: 'Lupe Fiasco'), double(RSpotify::Artist, name: 'JAY Z'), double(RSpotify::Artist, name: 'Childish Gambino'), double(RSpotify::Artist, name: 'Pusha T'), double(RSpotify::Artist, name: 'Kid Ink'), double(RSpotify::Artist, name: 'A$AP Rocky'), double(RSpotify::Artist, name: 'ScHoolboy Q'), double(RSpotify::Artist, name: 'The-Dream')]
    end
    artist_search_drake = [artist_drake, artist_drake, artist_drake, artist_drake]
    allow(RSpotify::Artist).to receive(:search).with('Drake').and_return(artist_search_drake)

    artist_chance = double(RSpotify::Artist, name: 'Chance The Rapper')
    allow(artist_chance).to receive(:top_tracks).with(:US) do
      [double(RSpotify::Track, name: 'No Problem (feat. Lil Wayne & 2 Chainz)'), double(RSpotify::Track, name: 'Juke Jam (feat. Justin Bieber & Towkio)'), double(RSpotify::Track, name: 'All Night (feat. Knox Fortune)'), double(RSpotify::Track, name: 'Same Drugs'), double(RSpotify::Track, name: "All We Got (feat. Kanye West & Chicago Children's Choir"), double(RSpotify::Track, name: 'Smoke Break (feat. Future)'), double(RSpotify::Track, name: 'Angels (feat. Saba)'), double(RSpotify::Track, name: 'Blessings (feat. Jeremih & Francis & The Lights)'), double(RSpotify::Track, name: 'Summer Friends'), double(RSpotify::Track, name: 'Mixtape (feat. Young Thug & Lil Yachty)')] 
    end
    allow(artist_chance).to receive(:related_artists) do
      [double(RSpotify::Artist, name: 'Vic Mensa'), double(RSpotify::Artist, name: 'Isaiah Rashad'), double(RSpotify::Artist, name: 'Ab-Soul'), double(RSpotify::Artist, name: 'Mick Jenkins'), double(RSpotify::Artist, name: 'Mac Miller'), double(RSpotify::Artist, name: 'Earl Sweatshirt'), double(RSpotify::Artist, name: 'Lupe Fiasco'), double(RSpotify::Artist, name: 'Frank Ocean'), double(RSpotify::Artist, name: 'A$AP Rocky'), double(RSpotify::Artist, name: 'Joey Bada$$'), double(RSpotify::Artist, name: 'Donnie Trumpet & The Social Experiment'), double(RSpotify::Artist, name: 'Vince Staples'), double(RSpotify::Artist, name: 'Domo Genesis'), double(RSpotify::Artist, name: 'Tyler, The Creator'), double(RSpotify::Artist, name: 'Pusha T'), double(RSpotify::Artist, name: 'Alex Wiley'), double(RSpotify::Artist, name: 'BJ The Chicago Kid'), double(RSpotify::Artist, name: 'GoldLink'), double(RSpotify::Artist, name: 'J. Cole'), double(RSpotify::Artist, name: 'Kanye West')]
    end
    artist_search_chance = [artist_chance, artist_chance, artist_chance, artist_chance]
    allow(RSpotify::Artist).to receive(:search).with('Chance The Rapper').and_return(artist_search_chance)

    artist_lupe = double(RSpotify::Artist, name: 'Lupe Fiasco')
    artist_search_lupe = [artist_lupe, artist_lupe, artist_lupe, artist_lupe]
    allow(RSpotify::Artist).to receive(:search).with('Lupe Fiasco').and_return(artist_search_lupe)

    allow(RSpotify::Artist).to receive(:search).with('Invalid Artist').and_return([])

    allow(RSpotify::Artist).to receive(:search).with('').and_return(nil)

    # RSpotify::Track Mocks
    song_drake_blessings = double(RSpotify::Track, name: 'Blessings', uri: 'spotify:track:1bzM1cd6oqFozdr4wK6HdR')
    song_search_drake_blessings = [song_drake_blessings, song_drake_blessings, song_drake_blessings, song_drake_blessings]    
    allow(RSpotify::Track).to receive(:search).with('Drake Blessings').and_return(song_search_drake_blessings)
    allow(RSpotify::Track).to receive(:search).with('Blessings Drake').and_return(song_search_drake_blessings)

    song_chance_angels = double(RSpotify::Track, name: 'Angels', uri: 'spotify:track:0jx8zY5JQsS4YEQcfkoc5C')
    song_search_chance_angels = [song_chance_angels, song_chance_angels, song_chance_angels, song_chance_angels]
    allow(RSpotify::Track).to receive(:search).with('Chance The Rapper Angels').and_return(song_search_chance_angels)
    allow(RSpotify::Track).to receive(:search).with('Angels Chance The Rapper').and_return(song_search_chance_angels)

    song_chance_blessings = double(RSpotify::Track, name: 'Blessings', uri: 'spotify:track:2VQc9orzwE6a5qFfy54P6e')
    song_search_chance_blessings = [song_chance_blessings, song_chance_blessings, song_chance_blessings, song_chance_blessings]   
    allow(RSpotify::Track).to receive(:search).with('Chance The Rapper Blessings').and_return(song_search_chance_blessings)
    allow(RSpotify::Track).to receive(:search).with('Blessings Chance The Rapper').and_return(song_search_chance_blessings)

    allow(RSpotify::Track).to receive(:search).with('Chance The Rapper Invalid Song').and_return([])
    allow(RSpotify::Track).to receive(:search).with('Invalid Song Chance The Rapper').and_return([])

    allow(RSpotify::Track).to receive(:search).with('').and_return(nil)
    allow(RSpotify::Track).to receive(:search).with(' ').and_return(nil)
    allow(RSpotify::Track).to receive(:search).with('Chance The Rapper ').and_return(nil)
    allow(RSpotify::Track).to receive(:search).with(' Chance The Rapper').and_return(nil)
  end
end
