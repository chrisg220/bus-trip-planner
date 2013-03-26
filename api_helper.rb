require 'uri'
require 'open-uri'
require 'json'



def stop_latlon_to_id(lat, lon, key)
  radius = 0.5

  oba_stop_id_lookup ="http://api.onebusaway.org/api/where/stops-for-location.json?key=" + key.to_s +
                      "&lat=" + lat.to_s +
                      "&lon=" + lon.to_s +
                      "&radius=" + radius.to_s
  stop= open(URI.escape(oba_stop_id_lookup)).read
  stop_json = JSON.parse(stop)

  #puts "    stop id " + stop_json["data"]["stops"][0]["id"].to_s
  return stop_json["data"]["stops"][0]["id"]
end


def bus_realtime(lat, lon, route, time, key)
  #http://api.onebusaway.org/api/where/arrivals-and-departures-for-stop/1_75403.json?key=TEST
  stop_id = stop_latlon_to_id(lat, lon, key)
  minutesAfter = 40
  time = time.to_i*1000
  oba_arrivals_for_stop ="http://api.onebusaway.org/api/where/arrivals-and-departures-for-stop/" + stop_id.to_s +
                           ".json?key=" + key.to_s + "&minutesAfter=" + minutesAfter.to_s

  arrivals = open(URI.escape(oba_arrivals_for_stop)).read
  puts URI.escape(oba_arrivals_for_stop)
  arrivals_json = JSON.parse(arrivals)
  stop_time=arrivals_json["data"]["arrivalsAndDepartures"].select { |n| (n["routeShortName"].to_i == route.to_i && n["scheduledDepartureTime"].to_i == time.to_i)}

  return stop_time[0]
end

def add_realtime_to_steps(step)
  lat = step["transit_details"]["departure_stop"]["location"]["lat"]
  lon = step["transit_details"]["departure_stop"]["location"]["lng"]
  bus_line = step["transit_details"]["line"]["short_name"]
  puts "START: bus line " + bus_line
  dep_time = step["transit_details"]["departure_time"]["value"]
  puts "    departure time: " + Time.at(dep_time).to_datetime.to_s
  puts "    departure utc: " + dep_time.to_s
  stop_time = bus_realtime(lat, lon, bus_line,dep_time, key)
  return stop_time["predictedArrivalTime"]
end

def is_bus?(step)
  if step["travel_mode"] == "TRANSIT" && step["transit_details"]["line"]["vehicle"]["type"] == "BUS"
    return true
  else
    return false
  end
end


def routes_real_time(origin, destination, time)




  sensor = false
  mode = "transit"
  alternatives = true
  time_by = "departure" # or arrival


  #http://maps.googleapis.com/maps/api/directions/json?origin=511%20North%20Boren%20Ave&destination=Northgate%20Mall,Seattle&sensor=false&mode=transit&alternatives=true&departure_time=1344905500
  google_url = "http://maps.googleapis.com/maps/api/directions/json?origin=" + origin +
                "&destination=" + destination +
                "&sensor=" + sensor.to_s +
                "&mode=" + mode +
                "&alternatives=" + alternatives.to_s +
                "&" + time_by + "_time=" + time.to_s

  json = open(URI.escape(google_url)).read
  parsed = JSON.parse(json)

  routes = Hash.new
  routes["origin"] = origin
  routes["destination"] = destination
  routes["start_address"] = parsed["routes"][0]["legs"][0]["start_address"]
  routes["end_address"] = parsed["routes"][0]["legs"][-1]["end_address"]
  routes["copyrights"] = parsed["routes"][0]["copyrights"]
  routes["routes"] = Array.new

  parsed["routes"].each_with_index do |route, r|
    routes["routes"][r]= Array.new
    route["legs"].each do |leg|
      leg["steps"].each_with_index do |step, l|
        routes["routes"][r][l] = Hash.new
        routes["routes"][r][l]["travel_mode"]= step["travel_mode"]
        routes["routes"][r][l]["html_instructions"]  = step["html_instructions"]
        if step["transit_details"]
          routes["routes"][r][l]["line"] = step["transit_details"]["line"]["short_name"]
          routes["routes"][r][l]["vehicle_name"] = step["transit_details"]["line"]["vehicle"]["name"]
          routes["routes"][r][l]["departure_stop"]= step["transit_details"]["departure_stop"]["name"]
          routes["routes"][r][l]["arrival_stop"] = step["transit_details"]["arrival_stop"]["name"]
          if is_bus?(step)
            real_time=add_realtime_to_steps(step)
            routes["routes"][r][l]["oba"] = real_time
          end
        end
      end
    end
  end
end


