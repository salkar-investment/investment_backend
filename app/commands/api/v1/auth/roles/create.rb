# frozen_string_literal: true

class Api::V1::Auth::Roles::Create < ::CreateCommand
  class Contract < Dry::Validation::Contract
    params do
      required(:resource).schema(Api::V1::Auth::Roles::Schema::RESOURCE_SCHEMA)
    end
  end
end
