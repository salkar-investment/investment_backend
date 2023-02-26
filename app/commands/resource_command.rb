# frozen_string_literal: true

class ResourceCommand < ApplicationCommand
  delegate :resource, to: :context

  private
    def resource_class
      return @resource_class if defined? @resource_class

      result = Meta::PredictResourceClass
                 .call(params: { class_name: self.class.name })
      context.fail!(errors: result.errors) if result.failure?

      @resource_class = result.resource_class
    end

    def resource_params
      permitted_params[:resource]
    end

    def fail_with_resource!(resource)
      errors = resource.errors.messages.map do |key, values|
        attrs = resource.attributes.keys
        mutate_name = !key.to_s.in?(attrs) && "#{key}_id".in?(attrs)
        values.map do |value|
          { key: mutate_name ? "resource.#{key}_id" : "resource.#{key}",
            value: }
        end
      end.flatten
      fail_with_errors!(errors)
    end
end
