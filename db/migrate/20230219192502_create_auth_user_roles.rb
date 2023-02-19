# frozen_string_literal: true

class CreateAuthUserRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_user_roles do |t|
      t.references :user, null: false, foreign_key: { to_table: :auth_users }
      t.references :role, null: false, foreign_key: { to_table: :auth_roles }
      t.index %i[role_id user_id], unique: true

      t.timestamps
    end
  end
end
