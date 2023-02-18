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
class Auth::Session < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :valid_to, presence: true

  belongs_to :user

  scope :active, -> { where("valid_to > ?", Time.current) }
  scope :outdated, -> { where("valid_to <= ?", Time.current) }
end
