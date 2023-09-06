class ApplicationController < ActionController::API
  include ActionController::Cookies

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  before_action :authorize

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authorize
    # Check if the request is trying to access actions that require authentication
    if action_requires_authentication?
      render json: { errors: ["Not authorized"] }, status: :unauthorized unless current_user
    end
  end

  private

  def action_requires_authentication?
    # List of actions that require authentication
    actions_requiring_authentication = [:create, :update, :destroy, :rate, :comment]

    # Check if the current action is in the list
    actions_requiring_authentication.include?(params[:action].to_sym)
  end

  def render_unprocessable_entity_response(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
