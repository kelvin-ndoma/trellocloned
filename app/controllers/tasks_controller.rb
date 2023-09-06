class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  # GET /boards/:board_id/lists/:list_id/cards/:card_id/tasks
  def index
    tasks = current_user.boards.find(params[:board_id]).lists.find(params[:list_id]).cards.find(params[:card_id]).tasks
    render json: tasks, status: :ok
  end

  # GET /boards/:board_id/lists/:list_id/cards/:card_id/tasks/1
  def show
    render json: @task, status: :ok
  end

  # POST /boards/:board_id/lists/:list_id/cards/:card_id/tasks
  def create
    task = current_user.boards.find(params[:board_id]).lists.find(params[:list_id]).cards.find(params[:card_id]).tasks.build(task_params)

    if task.save
      render json: task, status: :created
    else
      render_record_invalid_response(task)
    end
  end

  # PATCH/PUT /boards/:board_id/lists/:list_id/cards/:card_id/tasks/1
  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render_record_invalid_response(@task)
    end
  end

  # DELETE /boards/:board_id/lists/:list_id/cards/:card_id/tasks/1
  def destroy
    @task.destroy
    head :no_content
  end

  private

  def require_login
    unless current_user
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def set_task
    @task = current_user.boards.find(params[:board_id]).lists.find(params[:list_id]).cards.find(params[:card_id]).tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end

  def render_record_invalid_response(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
