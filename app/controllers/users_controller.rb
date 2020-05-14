class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user
      flash[:danger] = t "static_page.user.undefine"
      redirect_to root_path
    
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:danger] = t "static_page.user.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  private
  
  def user_params
  	params.require(:user).permit User::USER_PARAMS
  end

end
