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
class Auth::Permission < ApplicationRecord
  validates :action, presence: true,
            uniqueness: { scope: %i[controller role_id] }
  validates :controller, presence: true

  belongs_to :role
  has_many :user_roles, through: :role
end
