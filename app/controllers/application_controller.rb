# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :current_session

  before_action :authenticate

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
end
