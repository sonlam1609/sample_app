class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t "flash.micropost_created"
      redirect_to root_path
    else
      flash[:danger] = t "flash.micropost_!created"
      @feed_items = current_user.feed.page(params[:page]).per(Settings.per_pages)
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micro.destroy_success"
    else
      flash[:danger] = t "micro.destroy_danger"
    end
    redirect_to request.referrer || root_path
  end

  private
  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path unless @micropost
  end
end
