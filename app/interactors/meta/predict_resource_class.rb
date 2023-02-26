# frozen_string_literal: true

class Meta::PredictResourceClass < ApplicationInteractor
  class Contract < Dry::Validation::Contract
    params do
      required(:class_name).filled(:string)
    end
  end

  def call
    parts = permitted_params[:class_name].split("::")[2..-2]
    class_name = parts.pop.singularize
    context.resource_class = parts.push(class_name).join("::").constantize
  end
end
