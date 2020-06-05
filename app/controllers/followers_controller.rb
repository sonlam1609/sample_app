class FollowersController < ApplicationController
  before_action :logged_in_user
  
  def index
    @title = t "relationships.followers"
    @users = current_user.followers.page(params[:page]).per(Settings.per_pages)
    render "users/show_follow"
  end
end
