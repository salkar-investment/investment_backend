# frozen_string_literal: true

class CreateAuthUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :password_attempts_left
      t.string :password_digest
      t.datetime :password_valid_to

      t.timestamps
    end
  end
end
