# frozen_string_literal: true

class Api::V1::Auth::SessionsController < BaseController
  skip_before_action :authenticate, only: :create
  skip_before_action :authorize, only: %i[create destroy]

  def create
    if result.success?
      render json: serializer.render(result.resource, view: :create),
             status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_session.destroy!
    head :no_content
  end
end
