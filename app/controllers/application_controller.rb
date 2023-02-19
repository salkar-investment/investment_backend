# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :current_session
  attr_reader :current_authorization

  before_action :authenticate
  before_action :authorize

  private
    def authenticate
      result = Auth::Authenticate
                 .call(params: { header: request.headers["Authorization"] })
      if result.success?
        @current_session = result.resource
        return
      end

      head :unauthorized
    end

    def authorize
      result = Auth::Authorize.call(params: {
        controller: params[:controller],
        action: params[:action],
        user_id: current_session.user_id
      })
      if result.success?
        @current_authorization = result.resource
        return
      end

      head :forbidden
    end
end
