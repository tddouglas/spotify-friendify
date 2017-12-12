class WelcomeController < ApplicationController
  def index
    @comment = Comment.new
    print "user logged in? #{logged_in?}"
    @comments = logged_in? ? Comment.where(user: current_user.accepted_friends << current_user) : []
  end
end
