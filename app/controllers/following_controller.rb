class FollowingController < ApplicationController
  before_action :logged_in_user
  
  def index
    @title = t "relationships.following"
    @users = current_user.following.page(params[:page]).per(Settings.per_pages)
    render "users/show_follow"
  end
end
