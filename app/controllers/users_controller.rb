class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :check_user, only: [:edit, :update]
  def new
     @user = User.new
     redirect_to user_path(current_user.id) if logged_in?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
    @user = current_user
    redirect_to tasks_path if @user.id !=  params[:id].to_i
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:admin)
  end

  def check_user
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      flash[:notice] = "編集権限がありません"
      redirect_to tasks_path
    end
  end
end
