class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.string :origin_name
      t.string :destination_name
      t.boolean :arrive_by
      t.string :time

      t.timestamps
    end
  end
end
