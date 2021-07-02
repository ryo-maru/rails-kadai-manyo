class TasksController < ApplicationController
   before_action :set_task, only: [:show, :edit, :update]

  def index
    @tasks = Task.all
  end
  # 追記する。render :new が省略されている。
  def new
    @task = Task.new
  end

  def show
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      redirect_to tasks_path, notice: "ブログを作成しました！"
    else
      # 入力フォームを再描画します。
      render :new
    end
  end

  def edit
  end


  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "ブログを編集しました！"
    else
      render :edit
    end
  end

  private
    def task_params
      params.require(:task).permit(:title, :content)
    end

    def set_task
      @task = Task.find(params[:id])
    end

end
