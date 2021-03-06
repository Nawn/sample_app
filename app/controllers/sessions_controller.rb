class SessionsController < ApplicationController
  def new
  end

  def create
    user_info = session_credentials
    user = User.find_by(email: user_info[:email].downcase)
    if user && user.authenticate(user_info[:password])
      log_in user
      user_info[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def session_credentials
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
