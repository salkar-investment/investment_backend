# frozen_string_literal: true

class ApplicationQuery < ApplicationInteractor
  private
    def resource_class
      return @resource_class if defined? @resource_class

      result = Meta::PredictResourceClass
                 .call(params: { class_name: self.class.name })
      context.fail!(errors: result.errors) if result.failure?

      @resource_class = result.resource_class
    end
end
