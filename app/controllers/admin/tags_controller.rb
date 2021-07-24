class Admin::TagsController < ApplicationController
#  before_action :check_login
  before_action :require_admin

  def new
    @tag = Tag.new
    @tags = Tag.all
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to new_admin_tag_path
    else
      render :new
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if @tag.destroy
      redirect_to new_admin_tag_path, notice:"#{@tag.name}ラベルを削除しました"
    else
      render :new
    end
  end

  private
  def tag_params
    params.require(:tag).permit(:name)
  end

  def require_admin
    unless current_user.admin?
    redirect_to tasks_path
    flash[:notice] = '管理者以外はアクセスを許可されていません'
    end
  end
end
