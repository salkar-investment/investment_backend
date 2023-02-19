# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_roles
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_auth_roles_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :auth_role, class: "Auth::Role" do
    sequence(:name) { |n| "Role #{n}" }
  end
end
