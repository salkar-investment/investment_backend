# frozen_string_literal: true

class DestroyCommand < ResourceCommand
  class Contract < Dry::Validation::Contract
    params do
      required(:id).filled(:integer)
    end
  end

  def call
    context.resource = resource_class.find(permitted_params[:id])
    fail_with_resource!(resource) unless resource.destroy
  end
end
