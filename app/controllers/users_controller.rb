class UsersController < ApplicationController
  before_action :auth_user, only: [:edit, :update, :destroy, :show]

  def new
    if logged_in?
      flash[:notice]="Please logout to register a new user."
      redirect_to current_user
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice]="Success."
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash.now[:notice]="User updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to root_url
  end

  private

  def auth_user
    if !logged_in?
      flash.now[:notice]="Please log in."
      redirect_to login_url
    else
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
