class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: :destroy
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(Settings.per_pages)
  end

  def show; end

  def edit; end

  def new
    @user = User.new
    if @user.save
      log_in @user
    else
      render :new
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:danger] = t "static_page.user.welcome"
      redirect_to @user
    else
      flash[:danger] = t "static_page.user.undefine"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "static_page.user.welcome"
      redirect_to @user
    else
      flash[:danger] = t "static_page.user.undefine"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "static_page.user.deleted"
    else
      flash[:danger] = t "static_page.user.delete"
    end
    redirect_to users_path
  end

  private
  
  def user_params
    params.require(:user).permit User::USER_PARAMS
  end
  
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "static_page.user.pls"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "static_page.user.undefine"
    redirect_to root_path
  end
end
