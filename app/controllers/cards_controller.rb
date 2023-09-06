class CardsController < ApplicationController
  before_action :require_login
  before_action :set_card, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  # GET /boards/:board_id/lists/:list_id/cards
  def index
    cards = current_user.boards.find(params[:board_id]).lists.find(params[:list_id]).cards
    render json: cards, status: :ok
  end

  # GET /boards/:board_id/lists/:list_id/cards/:id
  def show
    render json: @card, status: :ok
  end

  # POST /boards/:board_id/lists/:list_id/cards
  def create
    card = current_user.boards.find(params[:board_id]).lists.find(params[:list_id]).cards.build(card_params)

    if card.save
      render json: card, status: :created
    else
      render_record_invalid_response(card)
    end
  end

  # PATCH/PUT /boards/:board_id/lists/:list_id/cards/:id
  def update
    if @card.update(card_params)
      render json: @card, status: :ok
    else
      render_record_invalid_response(@card)
    end
  end

  # DELETE /boards/:board_id/lists/:list_id/cards/:id
  def destroy
    @card.destroy
    head :no_content
  end

  private

  def require_login
    unless current_user
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def set_card
    @card = current_user.boards.find(params[:board_id]).lists.find(params[:list_id]).cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :description)
  end

  def render_record_invalid_response(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
