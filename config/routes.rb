# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_sidekiq_session"
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  # Protect against timing attacks:
  # - See https://codahale.com/a-lesson-in-timing-attacks/
  # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(Rails.application.secrets.sidekiq_username)
  ) & ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(Rails.application.secrets.sidekiq_password)
  )
end

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "/sidekiq"
end
