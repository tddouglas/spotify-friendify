# Final Project: Powerfy
Due **November 9, 2017 at 11:59pm**.

## Before Starting
Be sure to review lectures <a href="https://www.seas.upenn.edu/~cis196/lectures/CIS196-2017f-lecture7.pdf" target="_blank">7</a> and <a href="https://www.seas.upenn.edu/~cis196/lectures/CIS196-2017f-lecture8.pdf" target="_blank">8</a>.

## Gems
Run the `bundle install` command to install all of the gems listed in the `Gemfile`.

## Task
In this homework, you will implement a Spotify Jukebox that interacts with the <a href="https://developer.spotify.com/web-api/" target="_blank">Spotify Web API</a> using the <a href="https://github.com/guilhermesad/rspotify" target="_blank">RSpotify gem</a>. You will be able to add artists and songs and play music.

## Spotify API & RSpotify Gem
The <a href="https://developer.spotify.com/web-api/tutorial/" target="_blank">Spotify Web API Tutorial</a> will walk you through getting set up with the API, but I've provided the basic steps below.
1. You will need a Spotify user account, it does not matter if it is Premium or Free. If you don't already have one, you can sign up at <a href="https://www.spotify.com" target="_blank">www.spotify.com</a>.
2. You will then have to register with Spotify Developer. To do this, go to the <a href="https://developer.spotify.com/my-applications" target="_blank">My Applications</a> page at the Spotify Developer website and log in if necessary. Complete all of the required steps
3. Now register an application, go back to the <a href="https://developer.spotify.com/my-applications" target="_blank">My Applications</a> page and click **Create a new application**.
4. Enter the name of the application ('Spotify Jukebox' or something similar) and click **Create**.
5. The application that appears will have a Client ID and Client Secret that you will need to use for authentication.

Now that you've registered your application, you will have to add your new keys to the app. As a general rule, you should always keep your API keys private. This section will walk you through setting your keys up using Rails secrets and the <a href="https://github.com/bkeepers/dotenv" target="_blank">dotenv gem</a>.
1. Open `config/secrets.yml` and add the following lines under `base`:
   ```yaml
   spotify_client_id: <%= ENV['SPOTIFY_CLIENT_ID'] %>
   spotify_client_secret: <%= ENV['SPOTIFY_CLIENT_SECRET'] %>
   ```
2. The above lines tell your application to read your client id and client secret from your environment variables. You'll notice that development, test, and production all inherit from `base`.
3. When you're writing your assignment, you will be working in the development environment. So let's set the environment variables for development. Create a file called `.env` in the root of your application and immediately add it to your <a href="https://git-scm.com/docs/gitignore" target="_blank">.gitignore</a> file. Since this file will contain your Spotify keys, you want to make sure that it doesn't get added to your GitHub repository.
4. Inside of the `.env` file, add two lines for your Spotify Client ID and Spotify Client Secret (be sure to add your actual keys within the quotes).
   ```
   SPOTIFY_CLIENT_ID="YOUR SPOTIFY CLIENT ID"
   SPOTIFY_CLIENT_SECRET="YOUR SPOTIFY CLIENT SECRET"
   ```
5. These keys will be read in `config/secrets.yml` and you can access them in your application with `Rails.application.secrets.spotify_client_id` and `Rails.application.secrets.spotify_client_secret`. 

Let's now set up the <a href="https://github.com/guilhermesad/rspotify" target="_blank">RSpotify gem</a> for use in the assignment. We will be using RSpotify to make requests to the Spotify Web API. When you make a GET request to the Spotify Web API, it returns data back in the form of JSON (very similar to a Ruby hash). Rather than making the requests by hand and directly working with the JSON, the RSpotify gem will handle this for you and turn the JSON into a Ruby object for easy use.
1. The gem should already be installed, so let's start by authenticating with the Spotify API. The RSpotify gem provides a convenient method for doing this.
2. Open up `config/application.rb` and add the following:
    ```ruby
    unless Rails.env.test?
       RSpotify::authenticate(Rails.application.secrets.spotify_client_id, Rails.application.secrets.spotify_client_secret)
   end
   ```
3. The above line will authenticate with RSpotify when you run the application. If all went well, you will now be able to start using RSpotify. To test that it worked, you can start a rails console (by running `rails c`) and enter `RSpotify::Artist.search('Drake')[0]`. It should return a Ruby object. If instead you get an error, you likely missed a step in the setup.

## Migrations
The migrations will be provided intact, run `rails db:create` and `rails db:migrate` to run the existing migrations.<br>
**Artist** The artists table has a name column.<br>
**Song** The songs table has a name column and a reference to the artists table.

## Models
### Artist

#### Associations
The `has_many` relationship with songs has already been defined for you. We want to make sure that when you create an artist, you can create a song along with it. To do this, you should use `accepts_nested_attributes_for`. Be sure to add `, reject_if: :all_blank`. (Refer to the lecture slides for help with this)

#### #artist_search
This method will query RSpotify's artist search and return an array containing all of the artists that match the search term. To do this, you should use the <a href="http://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Artist#search-class_method" target="_blank">`RSpotify::Artist.search` method</a>, pass it the artist's `name` as a parameter, and return the array that gets returned.

#### Validations
You should validate the presence and uniquness of the artist's name.<br>
You should also add a custom validation that checks if the artist's `name` is present in the Spotify API database. Inside of the custom validation, you should immediately return if the `name` is blank. You should call the `artist_search` method, if the array returned by `artist_search` is empty, you should add an error to `:base` with the text `'Must be a valid artist in Spotify'`. (`errors.add(:base, 'Must be a valid artist in Spotify')`)

#### #related_artists
Immediately return `nil` if the artist is not valid (you can use the `valid?` method here). Call `artist_search` and get the first element from the array that it returns. Call the <a href="http://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Artist#related_artists-instance_method" target="_blank">`related_artists` method</a> on this element. `related_artists` will return an array of Ruby objects and each of those Ruby objects will have a name attribute. Map this array of Ruby objects to an array with just the names of each object (you can use the <a href="https://ruby-doc.org/core-2.4.1/Array.html#method-i-map" target="_blank">`map` method</a> here). Return the resulting array of just string names.

#### #top_tracks
Immediately return `nil` if the artist is not valid. Call `artist_search` and get the first element from the array that it returns. Call the <a href="http://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Artist#top_tracks-instance_method" target="_blank">`top_tracks` method</a> with the argument `:US` on this element. Map this array of Ruby objects to an array with just the names of each object. Furthermore, if a name contains a `(`, you should remove it and everything that follows in the string. Be sure to strip any remaining whitespace once this step is complete. Return the resulting array.

### Song
#### #song_search
This method will query RSpotify's track search and return an array containing all of the tracks that match the search term. To do this, you should use the <a href="http://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Track#search-class_method" target="_blank">`RSpotify::Track.search` method</a>, pass it a space-separated string containing the song's artist's `name` and the song's `name`, and return the array that gets returned.

#### Validations
You should validate the presence of the `name` and the uniqueness of the `name` in the scope of the `artist`.<br>
You should also define a custom validation that checks if the track is present in the Spotify API database. Inside of the custom validation, you should immediately return if the artist is nil, the artist's `name` is blank or if the song's `name` is blank. If the array returned by the `song_search` method is empty, you should add an error to `:base` with the text `'Must be a valid song for the artist in Spotify'`).

#### #spotify_uri
Immediately return `nil` if the song is not valid. Call `song_search` and get the first element from the array that it returns. Call the <a href="" target="_blank">`uri` method</a> on this element and return the value. This method will allow us to display a Spotify player and actually play the song.

## Controller
The controllers are being provided to you almost entirely intact. You will just have to make a few modifications to get the app completely up and running.

### Artist
#### new
We want to be able to create up to 3 songs when creating an artist. To accomplish it, you should call `build` on `@artist.songs` three times in this method.

#### artist_params
We need to make sure that our form can accept `params` for songs. To do this, add `songs_attributes` with the key `name` to the list of params permitted by `artist_params`.

## Views
The views are provided mostly intact, you just have to make a few modifications.

### Artist
#### \_form
We want to be able to add songs when we are creating a new artist. To do this, use `f.fields_for` and add a label and text field for the song's `name`.

### Song
#### \_form
Change the first line of the form to accept an array containing `[artist, song]` instead of just song.

At this point, I would run `rspec` and `rubocop` to make sure that you are passing all tests. You can do your first submission here if you'd like, you won't be making a lot of additional significant changes.

## Deploy to Heroku
Deploy your assignment to Heroku! Name the app 'cis196-2017f-hw8-github_username' (be sure to replace github_username with your actual GitHub username). If you end up calling it anything else, let your TA know by sending them a quick email (otherwise they won't be able to find it and you'll lose all points for it). <a href="https://guides.railsapps.org/rails-deploy-to-heroku.html" target="_blank">This guide</a> is incredible and has a step-by-step walkthrough that explains how to deploy your app. Please read everything below before starting the guide.

We will not be grading your Heroku deployment for correctness, you will receive full credit for this part as long as the app is deployed and functioning (it's okay if we run into a few errors while executing).

While deploying, there is a step that involves setting heroku environment vairables. When you get to this step, you want to be sure to set `heroku config:add SPOTIFY_CLIENT_ID='YOUR SPOTIFY CLIENT ID'` and `heroku config:add SPOTIFY_CLIENT_SECRET='YOUR SPOTIFY CLIENT SECRET'` where the stuff between the quotes is replaced with your actual keys from a little while ago.

You can stop reading the guide once you've run the database migrations and visited the site.

## Submitting
To submit the assignment, `cd` into the Homework 8 directory. Run `git status` to see all of the changes that you've made. Run `git add .` to add all of the changed files and `git status` to confirm that they all appear in green. Run `git commit -m "Complete Homework 8"` to commit your changes locally (note that you can change the commit message to anything you want). Run `git push -u origin master` to push up the changes to your Homework 8 GitHub repository.

Visit Travis CI to see the result of your submission. You will be able to see all of your failed test cases and style offenses. You can submit as many times as you'd like, only your last submission will be graded.
