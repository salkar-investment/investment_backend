# frozen_string_literal: true

class Api::V1::Auth::RolesSerializer < ApplicationSerializer
  identifier :id

  fields :name
end
