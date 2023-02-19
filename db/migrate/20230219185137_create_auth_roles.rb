# frozen_string_literal: true

class CreateAuthRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_roles do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
