# frozen_string_literal: true

class Auth::Authorize < ApplicationInteractor
  Authorization = Struct.new(:permissions, :modifiers, keyword_init: true)
  class Contract < Dry::Validation::Contract
    params do
      required(:controller).filled(:string)
      required(:action).filled(:string)
      required(:user_id).filled(:integer)
    end
  end

  def call
    fail!("base", t(".no_permissions")) if permissions.blank?

    context.resource = Authorization.new(permissions:, modifiers:)
  end

  private
    def permissions
      @permissions ||=
        Auth::Permission.joins(:user_roles)
                        .where(controller: permitted_params[:controller],
                               action: permitted_params[:action],
                               auth_user_roles: {
                                 user_id: permitted_params[:user_id]
                               })
    end

    def modifiers
      permissions.map(&:modifiers).flatten.uniq
    end
end
