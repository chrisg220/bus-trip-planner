class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.references :trip
      t.text :response
      t.string :duration
      t.timestamp :start_time
      t.timestamp :end_time
      t.text :snapshot

      t.timestamps
    end
    add_index :routes, :trip_id
  end
end
