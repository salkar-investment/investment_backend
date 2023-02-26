# frozen_string_literal: true

class Api::V1::Auth::Roles::Update < ::UpdateCommand
  class Contract < Dry::Validation::Contract
    params do
      required(:id).filled(:integer)
      required(:resource).schema(Api::V1::Auth::Roles::Schema::RESOURCE_SCHEMA)
    end
  end
end
