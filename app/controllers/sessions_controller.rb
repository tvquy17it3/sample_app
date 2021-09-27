class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if checked_attemp(user)
      if user.activated
        log_in user
        checked_remember user
        redirect_back_or user
      else
        message = t "user_mailer.account_not_activated"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def checked_attemp user
    user.try(:authenticate, params[:session][:password])
  end
end
