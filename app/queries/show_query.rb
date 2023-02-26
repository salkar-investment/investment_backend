# frozen_string_literal: true

class ShowQuery < ApplicationQuery
  class Contract < Dry::Validation::Contract
    params do
      required(:id).filled(:integer)
    end
  end

  def call
    context.resource = resource_class.find(permitted_params[:id])
  end
end
