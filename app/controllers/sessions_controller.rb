class SessionsController < ApplicationController
  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = Session.all
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  # GET /login
  def new
    @user = User.new
  end

  # GET /sessions/1/edit
  def edit
  end

  # POST /login
  def create
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @user = User.from_omniauth(request.env['omniauth.auth'], spotify_user)
    return if @user.nil?
    session[:user_id] = @user.id
    redirect_to '/'
  end

  # DELETE /logout
  def destroy
    if current_user
      session.delete(:user_id)
    end
    redirect_to root_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_session
    @session = Session.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.fetch(:session, {})
  end
end
