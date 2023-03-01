# frozen_string_literal: true

class Api::V1::Auth::Sessions::Create < ::ResourceCommand
  TOKEN_BYTE_LENGTH = 30
  SESSION_VALID = 1.week

  class Contract < Dry::Validation::Contract
    params do
      required(:resource).schema do
        required(:email).filled(:string)
        required(:password).filled(:string)
      end
    end
  end

  def call
    fail_with_default_error! unless user

    authenticate
    ApplicationRecord.transaction do
      context.resource = user.sessions.create!(
        token: generate_token, valid_to: SESSION_VALID.since
      )
      user.update!(
        password: nil, password_attempts_left: nil, password_valid_to: nil
      )
    end
  end

  private
    def user
      return @user if defined? @user

      @user = Auth::User.find_by(email: resource_params[:email].downcase)
    end

    def authenticate
      fail_with_default_error! unless user.password_valid_to&.future?
      fail_with_default_error! unless user.password_attempts_left&.positive?
      return if user.authenticate(resource_params[:password])

      Auth::User
        .where(id: user.id)
        .update_all("password_attempts_left = password_attempts_left - 1")
      fail_with_default_error!
    end

    def generate_token
      token = SecureRandom.urlsafe_base64(TOKEN_BYTE_LENGTH, false)
      token = generate_token if Auth::Session.exists?(token:)
      token
    end

    def fail_with_default_error!
      fail!("base", t(".common_error"))
    end
end
