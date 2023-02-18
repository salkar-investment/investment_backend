# frozen_string_literal: true

class Auth::Authenticate < ApplicationInteractor
  PREFIX = "Bearer "

  class Contract < Dry::Validation::Contract
    params do
      required(:header).filled(:string)
    end
  end

  delegate :resource, to: :context

  def call
    unless permitted_params[:header]&.starts_with?(PREFIX)
      fail!("header", t("invalid"))
    end

    context.resource =
      Auth::Session.active
                   .find_by(token: permitted_params[:header].sub(PREFIX, ""))
    fail!("base", t(".session_not_found")) unless resource
  end
end
