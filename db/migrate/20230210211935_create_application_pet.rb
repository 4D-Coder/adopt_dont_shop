class CreateApplicationPet < ActiveRecord::Migration[5.2]
  def change
    create_table :application_pets do |t|
      t.references :pet, foreign_key: true
      t.references :application, foreign_key: true
      t.integer :approval, default: 0 
    end
  end
end
