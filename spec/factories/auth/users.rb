# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_users
#
#  id                     :bigint           not null, primary key
#  email                  :string           not null
#  first_name             :string           not null
#  last_name              :string           not null
#  password_attempts_left :integer
#  password_digest        :string
#  password_valid_to      :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_auth_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :auth_user, class: "Auth::User" do
    sequence(:email) { |n| "test#{n}@example.com" }
    first_name { "John" }
    last_name { "Smith" }

    trait :with_password do
      password { "test" }
      password_attempts_left { 20 }
      password_valid_to { 1.day.since }
    end
  end
end
