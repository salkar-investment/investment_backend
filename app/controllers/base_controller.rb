# frozen_string_literal: true

class BaseController < ApplicationController
  def index
    return render_errors if result.failure?

    collection = result.collection
    render json: serializer.render(
      collection,
      root: :data,
      meta: {
        current_page: collection.current_page,
        total_pages: collection.total_pages
      },
      view: :index
    )
  end

  def show
    return render_errors if result.failure?

    render json: serializer.render(result.resource, view: :show)
  end

  def create
    return render_errors if result.failure?

    render json: { id: result.resource.id }, status: :created
  end

  def update
    return render_errors if result.failure?

    head :no_content
  end

  def destroy
    return render_errors if result.failure?

    head :no_content
  end

  private
    def serializer
      self.class.name.sub("Controller", "Serializer").constantize
    end

    def service_class
      name = params[:action].capitalize
      self.class.name.sub("Controller", "::#{name}").constantize
    end

    def result
      @result ||=
        service_class.call(params:, current_session:, current_authorization:)
    end

    def render_errors
      render json: { errors: result.errors }, status: result.status
    end
end
