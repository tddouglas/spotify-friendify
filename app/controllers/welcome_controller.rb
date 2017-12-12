class WelcomeController < ApplicationController
  def index
    @comment = Comment.new
    @comments = logged_in? ? Comment.where(user: current_user.accepted_friends << current_user) : []
  end
end
