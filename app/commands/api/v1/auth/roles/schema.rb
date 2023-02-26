# frozen_string_literal: true

class Api::V1::Auth::Roles::Schema
  RESOURCE_SCHEMA = Dry::Schema.Params do
    required(:name).filled(:string)
  end
end
