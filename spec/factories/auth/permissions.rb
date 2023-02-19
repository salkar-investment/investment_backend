# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_permissions
#
#  id         :bigint           not null, primary key
#  action     :string           not null
#  controller :string           not null
#  modifiers  :string           default([]), not null, is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :bigint           not null
#
# Indexes
#
#  index_auth_permissions_on_action_and_controller_and_role_id  (action,controller,role_id)
#  index_auth_permissions_on_role_id                            (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => auth_roles.id)
#
FactoryBot.define do
  factory :auth_permission, class: "Auth::Permission" do
    controller { "api/v1/users" }
    action { "update" }
    association :role, factory: :auth_role
    modifiers { ["email"] }
  end
end
