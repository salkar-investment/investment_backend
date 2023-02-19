# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_user_roles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_auth_user_roles_on_role_id              (role_id)
#  index_auth_user_roles_on_role_id_and_user_id  (role_id,user_id) UNIQUE
#  index_auth_user_roles_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => auth_roles.id)
#  fk_rails_...  (user_id => auth_users.id)
#
FactoryBot.define do
  factory :auth_user_role, class: "Auth::UserRole" do
    association :user, factory: :auth_user
    association :role, factory: :auth_role
  end
end
