# frozen_string_literal: true

class Auth::AvailablePermissions::Index < ApplicationInteractor
  BASE_ACTION_SETTINGS = { "modifiers" => [] }.freeze
  CRUD_ACTIONS = %w[create index show update destroy]
                   .index_with { |action| BASE_ACTION_SETTINGS }.freeze
  PERMISSIONS = {
    "api/v1/auth/roles" => CRUD_ACTIONS
  }.freeze
end
