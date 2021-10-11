class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :check_admin, only: :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.show_10)
  end

  def show
    @microposts = @user.microposts.paginate(
      page: params[:page],
      per_page: Settings.show_10
    )
  end

  def new
    @user = User.new
  end

  def edit; end

  def following
    @title = t "follow.following"
    @users = @user.following.paginate(
      page: params[:page], per_page: Settings.show_10
    )
    render "show_follow"
  end

  def followers
    @title = t "follow.followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(
      page: params[:page], per_page: Settings.show_10
    )
    render "show_follow"
  end

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
      flash.now[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def check_admin
    return if current_user.admin?

    redirect_to root_url
  end
end
