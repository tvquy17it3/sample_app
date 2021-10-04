class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if check_attemp(user)
      if user.activated
        log_in user
        check_remember user
        redirect_back_or user
      else
        flash[:warning] = t "user_mailer.account_not_activated"
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

  def check_attemp user
    user.try(:authenticate, params[:session][:password])
  end
end
