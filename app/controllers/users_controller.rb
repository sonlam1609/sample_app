class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)
  before_action :admin_user, only: %i(destroy)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.page(params[:page]).per(Settings.per_pages)
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per(Settings.per_pages)
  end

  def edit; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "mailer.title"
      redirect_to root_url
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
