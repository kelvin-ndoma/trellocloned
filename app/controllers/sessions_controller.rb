class SessionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      cookies.signed[:user_id] = { value: user.id, httponly: true } # Set the session cookie
      render json: user, status: :ok
    else
      render json: { errors: ["Invalid email or password"] }, status: :unauthorized
    end
  end
  

  def destroy
    if session.include?(:user_id)
      session.delete :user_id
      render json: {}, status: :no_content
    else
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  private

  def render_record_not_found(e)
    render json: { errors: ["User not found"] }, status: :unauthorized
  end
end

