class RealTimeController < ApplicationController

  # expects the following parameters:
  #   :stop_id => A OBA formatted stop_id (ex. 1_75403)
  #   :route => OBA route identifier,
  #   :sched_time => scheduled departure time
  #
  # makes a request to One Bus Away API for
  # real time arrival info for this stop:
  #
  # http://api.onebusaway.org/api/where/arrivals-and-departures-for-stop/1_75403.json?key=TEST
  #
  # filters the responses out to get the stop info specific to the
  # :sched_time paramter
  def fetch
    key = "05d03911-aeb2-4989-a095-7823ff397bed"
    stop_id = params[:stop_id]
    route = params[:route]
    time = params[:sched_time].to_i * 1000
    minutesAfter = 40

    oba_arrivals_for_stop_url = "http://api.onebusaway.org/api/where/" +
                              "arrivals-and-departures-for-stop/" +
                              stop_id.to_s + ".json?key=" + key.to_s

    puts oba_arrivals_for_stop_url

    arrivals_json = JSON.parse(open(URI.escape(oba_arrivals_for_stop_url)).read)

    arrivalsAndDepartures = arrivals_json["data"]["arrivalsAndDepartures"]

    arrival_time = arrivalsAndDepartures.select do |n|
      n["routeShortName"].to_i == route.to_i && n["scheduledDepartureTime"].to_i == time.to_i
    end

    @response = { "stop_id" => stop_id }

    if arrival_time[0]
      if arrival_time[0]["predictedDepartureTime"] == 0
        @response["status"] = "unknown"
      else
        diff = arrival_time[0]["predictedDepartureTime"] - arrival_time[0]["scheduledDepartureTime"]
        diff = diff/1000

        if diff == 0
          # on time
          @response["status"] = "on time"
        else
          if diff < 0
            # early!
            @response["status"] = "early"
          else
            # late
            @response["status"] = "late"
          end
          @response["m"] = (diff / 60).to_i
          @response["s"] = diff % 60
        end
      end
    end

    render :json => @response
  end
end
