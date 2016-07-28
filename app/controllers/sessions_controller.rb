class SessionsController < ApplicationController
  def new
    redirect_to current_user if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login(user)
      redirect_to root_url
    else
      flash.now[:notice]="* Invalid email/password combination."
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
