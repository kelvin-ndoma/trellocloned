class ListsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  # GET /boards/:board_id/lists
  def index
    board = current_user.boards.find_by(id: params[:board_id])
    if board
      lists = board.lists
      render json: lists, status: :ok
    else
      render json: { errors: ["Board not found"] }, status: :not_found
    end
  end

  # GET /boards/:board_id/lists/1
  def show
    list = current_user.boards.find_by(id: params[:board_id]).lists.find_by(id: params[:id])
    if list
      render json: list, status: :ok
    else
      render json: { errors: ["List not found"] }, status: :not_found
    end
  end

  # POST /boards/:board_id/lists
  def create
    board = current_user.boards.find_by(id: params[:board_id])
    if board
      list = board.lists.build(list_params)

      if list.save
        render json: list, status: :created
      else
        render_record_invalid_response(list)
      end
    else
      render json: { errors: ["Board not found"] }, status: :not_found
    end
  end

  # PATCH/PUT /boards/:board_id/lists/1
  def update
    list = current_user.boards.find_by(id: params[:board_id]).lists.find_by(id: params[:id])
    if list
      if list.update(list_params)
        render json: list, status: :ok
      else
        render_record_invalid_response(list)
      end
    else
      render json: { errors: ["List not found"] }, status: :not_found
    end
  end

  # DELETE /boards/:board_id/lists/1
  def destroy
    list = current_user.boards.find_by(id: params[:board_id]).lists.find_by(id: params[:id])
    if list
      list.destroy
      head :no_content
    else
      render json: { errors: ["List not found"] }, status: :not_found
    end
  end

  private

  def list_params
    params.require(:list).permit(:title)
  end

  def render_record_invalid_response(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
