class UsersController < ApplicationController
  before_action :set_user, only:
    [:show, :edit, :update, :destroy, :correct_user]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.show_10)
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user_mailer.check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    if @user&.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_url
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end

  def user_params
    prs = [:name, :email, :password, :password_confirmation]
    params.require(:user).permit prs
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
end
