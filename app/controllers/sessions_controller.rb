class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user.try(:authenticate, params[:session][:password])
      log_in user
      check_remember user
      redirect_back_or user
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
