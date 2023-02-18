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
class Auth::User < ApplicationRecord
  has_secure_password(validations: false)

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :sessions, dependent: :delete_all
end
