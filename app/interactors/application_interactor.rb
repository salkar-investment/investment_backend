# frozen_string_literal: true

class ApplicationInteractor
  include Interactor

  delegate :permitted_params, to: :context

  def self.inherited(klass)
    klass.class_eval do
      before do
        contract = klass::Contract.new
        result = contract.call(raw_params)
        fail_with_validation!(result) if result.errors.present?

        context.permitted_params = result.to_h
      end
    end
  end

  private
    def fail_with_validation!(result)
      errors = result.errors.map do |e|
        { key: e.path.join("."), value: e.text }
      end
      fail_with_errors!(errors)
    end

    def raw_params
      result = context.params
      result = result.permit!.to_h if result.is_a?(ActionController::Parameters)
      result
    end

    def t(str)
      I18n.t(i18n_token(str))
    end

    def i18n_token(name)
      return name unless name.start_with?(".")

      "#{self.class.to_s.underscore.tr('/', '.')}#{name}"
    end

    def fail!(key, value, meta = nil, status: :unprocessable_entity)
      context.fail!(errors: [{ key:, value: }.merge({ meta: }.compact)],
status:)
    end

    def fail_with_errors!(errors, status: :unprocessable_entity)
      context.fail!(errors: Array.wrap(errors), status:)
    end
end
