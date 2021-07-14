class TasksController < ApplicationController
   before_action :set_task, only: [:show, :edit, :update, :destroy]


  def index

    @tasks = current_user.tasks



    # @tasks = Task.all.order(created_at: :desc)
    if params[:sort_expired]
    #  @tasks = Task.all.page(params[:page]).per(20)
      @tasks = @tasks.order(deadline: :desc).page(params[:page]).per(20)
    elsif params[:sort_priority]
    #  @tasks = Task.all.page(params[:page]).per(20)
      @tasks = @tasks.order(priority: :desc).page(params[:page]).per(20)
    else
    #  @tasks = current_user.tasks.page(params[:page]).per(20)
      @tasks = @tasks.order(created_at: :desc).page(params[:page]).per(20)
    #  @tasks = Task.all.order(id: "DESC").page(params[:page]).per(20)
    end

    if params[:task].present?
      #@tasks = current_user.tasks
      if params[:title].present? && params[:task][:status].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%").page(params[:page]).per(20)
        @tasks = @tasks.where(status: params[:task][:status]).page(params[:page]).per(20)

      elsif params[:task][:title].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%").page(params[:page]).per(20)

      elsif params[:task][:status].present?
        @tasks = @tasks.where(status: params[:task][:status]).page(params[:page]).per(20)
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
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      redirect_to tasks_path, notice: "タスクを作成しました！"
    else
      # 入力フォームを再描画します。
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
      params.require(:task).permit(:title, :content, :deadline, :status, :priority)
    end

    def set_task
      @task = Task.find(params[:id])
    end

end
