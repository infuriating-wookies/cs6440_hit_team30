class CreateUserMedications < ActiveRecord::Migration
  def change
    create_table :user_medications do |t|
      t.references :user, index: true, foreign_key: true
      t.references :medication, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
