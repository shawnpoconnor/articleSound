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
      login(@user)
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
    @article = Article.new
    @history = @user.user_articles.where(listened: true).order("updated_at DESC").limit(5)
    @queue = @user.user_articles.where(listened: false).order("created_at DESC").limit(5)
  end

  def destroy
    log_out
    User.find(params[:id]).destroy
    redirect_to root_url
  end

  def password
    if logged_in?
      @user = current_user
      render 'password'
    else
      redirect_to login_url
    end
  end

  def update_password
    @user = current_user
    if @user.authenticate(params[:user][:current_password]) && @user.update_attributes(password_params)
      flash[:notice]="Password changed."
      redirect_to @user
    elsif @user.errors.count > 0
      render 'password'
    else
      @errors= "* Wrong password. Please enter your current password."
      render 'password'
    end
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


  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
