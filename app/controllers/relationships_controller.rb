class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_followed, only: :create

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_followed
    @user = User.find_by(id: params[:followed_id])
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end
end
