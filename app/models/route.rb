class Route < ActiveRecord::Base
  attr_accessible :duration, :end_time, :response, :snapshot, :start_time, :trip_id, :route_json
  attr_accessor :route_json
  # the following macro may be needed, it is a
  # quick and dirty macro for making variables accessible to self methods
  #attr_accessor :duration, :end_time, :response, :snapshot, :start_time
  belongs_to :trip
  before_create :parse_gmaps



  private

  def parse_gmaps
    require 'json'
    legs = Array.new
    travel_modes = Array.new
    self.route_json["legs"].each do |leg|
      self.duration = leg["duration"]["text"]
      self.end_time = (leg["arrival_time"]) ? leg["arrival_time"]["value"].to_i : -1
      self.start_time = (leg["departure_time"]) ? leg["departure_time"]["value"].to_i : -1
      leg["steps"].each_with_index do |step, l|
        legs[l] = Hash.new
        legs[l]["travel_mode"]= step["travel_mode"]
        travel_modes << step["travel_mode"]
        legs[l]["html_instructions"]  = step["html_instructions"]
        legs[l]["duration"] = step["duration"]["text"]
        #legs[l]["duration_int"] = step["duration"]["value"]
        if step["transit_details"]
          legs[l].update(transit_details(step))
        end
      end
    end
    #this returns a string
    self.response = JSON.generate(legs)
    #JSON.parse returns the data structure exactly
    self.snapshot = JSON.generate(travel_modes)
  end



  def transit_details (step)
    key = "05d03911-aeb2-4989-a095-7823ff397bed"
    td= step["transit_details"]
    t_hash = Hash.new
    t_hash["line"] = td["line"]["short_name"]
    t_hash["vehicle_name"] = td["line"]["vehicle"]["name"]
    t_hash["departure_stop"]= td["departure_stop"]["name"]
    t_hash["arrival_stop"] = td["arrival_stop"]["name"]
    t_hash["lat"]= td["departure_stop"]["location"]["lat"]
    t_hash["lon"] = td["departure_stop"]["location"]["lng"]
    if is_bus?(step)
      t_hash["stop_id"] = stop_id(t_hash["lat"], t_hash["lon"], key)
    end
    return t_hash
  end

  def stop_id(lat, lon, key)
    require 'uri'
    require 'open-uri'
    require 'json'
    radius = 0.5
    oba_stop_id_lookup ="http://api.onebusaway.org/api/where/stops-for-location.json?key=" + key.to_s +
                        "&lat=" + lat.to_s +
                        "&lon=" + lon.to_s +
                        "&radius=" + radius.to_s
    puts oba_stop_id_lookup
    stop = open(URI.escape(oba_stop_id_lookup)).read
    stop_json = JSON.parse(stop)
    puts stop_json
    if stop_json["text"] == "OK"
      return stop_json["data"]["stops"][0]["id"]
    else
      nil
    end
  end

  def is_bus?(step)
    if step["travel_mode"] == "TRANSIT" && step["transit_details"]["line"]["vehicle"]["type"] == "BUS"
      return true
    else
      return false
    end
  end

end

