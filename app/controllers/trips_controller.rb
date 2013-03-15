class TripsController < ApplicationController
  def index
    @trip = Trip.all
  end

  def new
    @trip = Trip.new
  end

  def create
    require 'uri'
    require 'open-uri'
    require 'json'

    @trip = Trip.new(params[:trip])

    origin = params[:trip][:origin_name]
    destination = params[:trip][:destination_name]
    time = (Time.now + 300).to_i.to_s

    sensor = false
    mode = "transit"
    alternatives = true
    time_by = "departure" # or arrival


    #http://maps.googleapis.com/maps/api/directions/json?origin=511%20North%20Boren%20Ave&destination=Northgate%20Mall,Seattle&sensor=false&mode=transit&alternatives=true&departure_time=1344905500
    url = "http://maps.googleapis.com/maps/api/directions/json?origin=" + origin +
              "&destination=" + destination +
              "&sensor=" + sensor.to_s +
              "&mode=" + mode +
              "&alternatives=" + alternatives.to_s +
              "&" + time_by + "_time=" + time

    @json = JSON.parse(open(URI.escape(url)).read)

    render 'new'
  end
end
