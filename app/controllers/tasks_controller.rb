class TasksController < ApplicationController
   before_action :set_task, only: [:show, :edit, :update, :destroy]


  def index
    # @tasks = Task.all.order(created_at: :desc)
    if params[:sort_expired]
      @tasks = Task.all
      @tasks = @tasks.order(deadline: :desc)
    else
      @tasks = Task.all
      @tasks = @tasks.order(created_at: :desc)
      @tasks = Task.all.order(id: "DESC")
    end

    if params[:task].present?
      #@tasks = current_user.tasks
      if params[:task][:title].present? && params[:task][:status].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")
        @tasks = @tasks.where(status: params[:task][:status])

      elsif params[:task][:title].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")

      elsif params[:task][:status].present?
        @tasks = @tasks.where(status: params[:task][:status])
      end
    end


    #if params[:search].present?
     #@tasks = Task.where('title LIKE ?', "%#{params[:search]}%") if params[:search].present?
    #@tasks = Task.where("task_name LIKE ?", "%#{params[:search]}%"
    #end

      #@tasks = Task.where(tasks.status, params[:status])
    #end
  #elsif params[:search].present? && params[:status] != ""
  #  @tasks = Task.where("task_name LIKE ?", "%#{params[:search]}%")
                  #.where(status: params[:status])
   #end

   #if params[:status].present?
   #@tasks = Task.where(status: params[:status])
 #end
  end
    #if params[:title]
    #@tasks = Task.where('title LIKE(?)', "%#{params[:keyword]}%")
    #else
    #end
#Product.where('title LIKE(?)', "%#{params[:keyword]}%")

  #if params[:task][:title].present? && params[:task][:status].present?
      # @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")
       #@tasks = @tasks.where(status: params[:task][:status])

     #elsif params[:task][:title].present?
      # @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")

     #elsif params[:task][:status].present?
      # @tasks = @tasks.where(status: params[:task][:status])
    # #end
   #end


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
