class TripsController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update, :delete, :save]

  def index
    # eventually this should only be trips that current_user has access to
    @trips = Trip.all
  end

  def new
    # anybody can create a trip and view the results
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

    json = open(URI.escape(url)).read

    @trip.origin_name = json["routes"][0]["start_address"]
    @trip.destination_name = json["routes"][0]["end_address"]
    @trip.raw_response = json.to_s

    if @trip.save
      flash[:notice] = "Trip stored, but not saved to user"
      redirect_to trip_path(@trip)
    else
      flash[:alert] = "Trip not stored"
      render 'new'
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @json = JSON.parse(@trip.raw_response)
    # this action will trigger SAVING the trip for the current user.
    # in create, the trip is saved but not assigned a user
    # in order to edit, delete, etc, the trip must first be saved
  end

  private

  def authenticate_user!
    # this is identical to ticketee
  end
end