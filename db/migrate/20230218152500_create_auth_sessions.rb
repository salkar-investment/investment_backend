# frozen_string_literal: true

class CreateAuthSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_sessions do |t|
      t.string :token, null: false, index: { unique: true }
      t.datetime :valid_to, null: false
      t.references :user, null: false, foreign_key: { to_table: :auth_users }

      t.timestamps
    end
  end
end
