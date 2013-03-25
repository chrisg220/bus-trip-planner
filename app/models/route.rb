class Route < ActiveRecord::Base
  attr_accessible :duration, :end_time, :response, :snapshot, :start_time, :trip_id
end
