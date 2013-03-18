class Trip < ActiveRecord::Base
  attr_accessible :arrive_by, :destination_name, :name, :origin_name, :time
  validates :origin_name, :destination_name, :presence => true
end
