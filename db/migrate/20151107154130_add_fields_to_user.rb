class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :address, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :postal_code, :string
  end
end
