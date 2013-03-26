class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :name
      t.decimal :lat
      t.decimal :lng
      t.integer :oba_id
      t.string :agency

      t.timestamps
    end
  end
end
