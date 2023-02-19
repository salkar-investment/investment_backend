# frozen_string_literal: true

class CreateAuthPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_permissions do |t|
      t.string :action, null: false
      t.string :controller, null: false
      t.references :role, null: false, foreign_key: { to_table: :auth_roles }
      t.string :modifiers, array: true, default: [], null: false
      t.index %i[action controller role_id]

      t.timestamps
    end
  end
end
