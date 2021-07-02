class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end
  # 追記する。render :new が省略されている。
  def new
    @task = Task.new
  end

  def create
    Task.create(task_params)
    redirect_to new_task_path
  end

  private
    def task_params
      params.require(:task).permit(:title, :content)
    end

end
