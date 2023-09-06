class BoardsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  # GET /boards
  def index
    user = User.find_by(id: session[:user_id])
    if user
      boards = user.boards
      render json: boards, status: :ok
    else
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  # GET /boards/1
  def show
    board = current_user.boards.find_by(id: params[:id])
    if board
      render json: board, status: :ok
    else
      render json: { errors: ["Board not found"] }, status: :not_found
    end
  end

  # POST /boards
  def create
    user = User.find_by(id: session[:user_id])
    if user
      board = user.boards.build(board_params)

      if board.save
        render json: board, status: :created
      else
        render_record_invalid_response(board)
      end
    else
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  # PATCH/PUT /boards/1
  def update
    board = current_user.boards.find_by(id: params[:id])
    if board
      if board.update(board_params)
        render json: board, status: :ok
      else
        render_record_invalid_response(board)
      end
    else
      render json: { errors: ["Board not found"] }, status: :not_found
    end
  end

  # DELETE /boards/1
  def destroy
    board = current_user.boards.find_by(id: params[:id])
    if board
      board.destroy
      head :no_content
    else
      render json: { errors: ["Board not found"] }, status: :not_found
    end
  end

  private

  def board_params
    params.require(:board).permit(:title)
  end

  def render_record_invalid_response(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
