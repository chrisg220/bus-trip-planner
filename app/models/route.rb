class Route < ActiveRecord::Base
  attr_accessible :duration, :end_time, :response, :snapshot, :start_time, :trip_id
  attr_accessor :route
  belongs_to :trip

  def parse_gmaps
    require 'json'
    legs = Array.new
    self.route["legs"].each do |leg|
      leg["steps"].each_with_index do |step, l|
        legs[l] = Hash.new
        legs[l]["travel_mode"]= step["travel_mode"]
        legs[l]["html_instructions"]  = step["html_instructions"]
        if step["transit_details"]
          legs[l]["line"] = step["transit_details"]["line"]["short_name"]
          legs[l]["vehicle_name"] = step["transit_details"]["line"]["vehicle"]["name"]
          legs[l]["departure_stop"]= step["transit_details"]["departure_stop"]["name"]
          legs[l]["arrival_stop"] = step["transit_details"]["arrival_stop"]["name"]
        end
      end
    end
    #this returns a string
    self.response = JSON.generate(legs)
    #JSON.parse returns the data structure exactly
  end
end
