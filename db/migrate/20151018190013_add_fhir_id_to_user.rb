class AddFhirIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :fhir_id, :integer
  end
end
