class TasksController < ApplicationController
   before_action :set_task, only: [:show, :edit, :update, :destroy]
   before_action :login_require

  def index

    @tasks = current_user.tasks
    #@tasks = @tasks.includes(:current_user)



    if params[:sort_expired]
      @tasks = @tasks.order(deadline: :desc).page(params[:page]).per(20)
    elsif params[:sort_priority]
      @tasks = @tasks.order(priority: :desc).page(params[:page]).per(20)
    else
      @tasks = @tasks.order(created_at: :desc).page(params[:page]).per(20)
    end

    if params[:task].present?
      if params[:title].present? && params[:task][:status].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%").page(params[:page]).per(20)
        @tasks = @tasks.where(status: params[:task][:status]).page(params[:page]).per(20)

      elsif params[:task][:title].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%").page(params[:page]).per(20)

      elsif params[:task][:status].present?
        @tasks = @tasks.where(status: params[:task][:status]).page(params[:page]).per(20)

      elsif params[:task][:tag].present?
      @tasks = current_user.tasks.search_tag(params[:task][:tag]).page(params[:page]).per(20)
      else
        @tasks = current_user.tasks.select(:id, :title, :content, :created_at,:status,:priority,:deadline).order(created_at: :DESC).page(params[:page]).per(20)
      end

    end



end

  def new
    @task = Task.new
  end

  def show
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "タスクを作成しました！"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
     redirect_to tasks_path, notice:"タスクを削除しました！"
  end

  private
    def task_params
      params.require(:task).permit(:title, :content, :deadline, :status, :priority,{ tag_ids: [] } )
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def login_require
    redirect_to new_session_path unless current_user
    end

end
