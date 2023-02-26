# frozen_string_literal: true

class UpdateCommand < ResourceCommand
  def call
    context.resource = resource_class.find(permitted_params[:id])
    fail_with_resource!(resource) unless resource.update(resource_params)
  end
end
