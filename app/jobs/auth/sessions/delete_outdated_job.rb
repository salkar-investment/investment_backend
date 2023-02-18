# frozen_string_literal: true

class Auth::Sessions::DeleteOutdatedJob < ApplicationJob
  def perform
    Auth::Session.outdated.delete_all
  end
end
