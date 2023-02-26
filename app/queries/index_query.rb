# frozen_string_literal: true

class IndexQuery < ApplicationQuery
  SHARED_SCHEMA = Dry::Schema.Params do
    optional(:page).maybe(:integer)
  end
  DATE_MATCHERS = %w[eq lt lteq gt gteq].freeze

  class Contract < Dry::Validation::Contract
    params(::IndexQuery::SHARED_SCHEMA)
  end

  def call
    context.collection = collection
  end

  def collection
    result = resource_class.ransack(permitted_params[:q])
                           .result({ distinct: }.compact)
                           .includes(includes)
    result = result.page(permitted_params[:page]).per(per_page) if paginate
    result
  end

  private
    def distinct; end

    def includes
      []
    end

    def paginate
      true
    end

    def per_page
      20
    end
end
