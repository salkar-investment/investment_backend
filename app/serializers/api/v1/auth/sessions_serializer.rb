# frozen_string_literal: true

class Api::V1::Auth::SessionsSerializer < ApplicationSerializer
  identifier :id

  fields :token, :valid_to

  view :create do
    exclude :id
  end
end
