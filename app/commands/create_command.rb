# frozen_string_literal: true

class CreateCommand < ResourceCommand
  def call
    context.resource = resource_class.new(resource_params)
    fail_with_resource!(resource) unless resource.save
  end
end
