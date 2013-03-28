class AddPolylineAndMapBoundsToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :polyline, :string
    add_column :routes, :map_bounds, :string
  end
end
