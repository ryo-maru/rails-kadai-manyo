class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  #before_action :not_logged_in
  #before_action :not_admin_use
  before_action :require_admin


  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def show

  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id), notice: 'ユーザー情報を変更しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "#{@user.name}さん関連のデータを削除しました"
    else
      redirect_to admin_users_path, notice: "管理権限者は、最低でも１人は必要です。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin, :show)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin
    if current_user.nil? || !current_user.admin?
      redirect_to tasks_path, notice: "管理者以外はアクセスできません。"
    end
  end
end
