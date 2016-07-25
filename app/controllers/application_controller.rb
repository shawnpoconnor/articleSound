class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?


  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user||=User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end



end

