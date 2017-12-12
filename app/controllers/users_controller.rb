class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @comment = Comment.new
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    create_helper(@user)
  end

  # GET /friend_requests
  def friend_requests
    redirect_to '/' unless logged_in?
  end

  # DELETE /users/:id/remove_friendship
  def remove_friendship
    @user = User.find_by_id(params[:id])
    redirect_to index unless logged_in?
    User.find_by_id(session[:user_id]).remove_friendship(@user)
    redirect_to User.find_by_id(session[:user_id])
  end

  # POST /users/:id/send_friend_request
  def send_friend_request
    @user = User.find_by_id(params[:id])
    if logged_in?
      User.find_by_id(session[:user_id]).send_friend_request(@user)
      redirect_to User.find_by_id(@user.id)
    else
      redirect_to index
    end
  end

  # PATCH /users/:id/accept_friend_request
  def accept_friend_request
    @user = User.find_by_id(params[:id])
    if logged_in?
      User.find_by_id(session[:user_id]).accept_friend_request(@user)
      redirect_to User.find_by_id(session[:user_id])
    else
      redirect_to index
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
        @user.id = session[:user_id]
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
    reset_session
  end

  private

  def create_helper(user)
    respond_to do |format|
      if user.save
        session[:user_id] = user.id
        format.html { redirect_to user, notice: 'User was successfully logged in.' }
        format.json { render :show, status: :created, location: user }
      else
        format.html { render :new }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
