class Trip < ActiveRecord::Base
  attr_accessible :arrive_by, :destination_name, :name, :origin_name, :time
end
