class TasksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_task, only: [:show, :edit, :update, :destroy]

  respond_to :js, only: [:change_state]

  def index
    respond_with(@tasks = Task.all.order('created_at'))
  end

  def show
    respond_with @task
  end

  def new
    respond_with(@task = Task.new)
  end

  def edit
  end

  def create
    respond_with(@task = Task.create(task_params))
  end

  def update
    @task.update(task_params)
    respond_with @task
  end

  def destroy
    @task.destroy if @task.user_id == current_user.id
    respond_with @task
  end

  def change_state
    @task = Task.find(params[:task_id])
    @task.change_state
  end

  private

  def load_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :state).merge(user_id: current_user.id)
  end
end
