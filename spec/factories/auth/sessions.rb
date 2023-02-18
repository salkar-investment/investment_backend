# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_sessions
#
#  id         :bigint           not null, primary key
#  token      :string           not null
#  valid_to   :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_auth_sessions_on_token    (token) UNIQUE
#  index_auth_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => auth_users.id)
#
FactoryBot.define do
  factory :auth_session, class: "Auth::Session" do
    sequence(:token) { |n| "Token_#{n}" }
    association :user, factory: :auth_user
    valid_to { 2.days.since }
  end
end
