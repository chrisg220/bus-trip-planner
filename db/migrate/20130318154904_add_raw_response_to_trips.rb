class AddRawResponseToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :raw_response, :text
  end
end
