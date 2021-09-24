class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user.try(:authenticate, params[:session][:password])
      log_in user
      params[:session][:remember_me] == Settings.checked_1 ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = t "invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
