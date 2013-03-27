#!/bin/env ruby
# encoding: utf-8

include TripsHelper

require 'uri'
require 'open-uri'
require 'json'

class TripsController < ApplicationController
  before_filter :find_trip, :only => [:show, :edit, :update, :destroy, :save]
  before_filter :authenticate_user!, :only => [:edit, :update, :destroy, :save]

  def index
    # eventually this should only be trips that current_user has access to
    @trips = Trip.all
  end

  def new
    # anybody can create a trip and view the results
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(params[:trip])
    #time = (Time.now + 300).to_i.to_s

    if @trip.save
      flash[:notice] = "Trip stored, but not saved to user"
      redirect_to trip_path(@trip)
    else
      flash.now[:alert] = "Origin and destination can't be blank. Please try again."
      render 'new'
    end
  end

  def show
    #@resp = route_api_request(@trip.origin_name, @trip.destination_name)

    unless @resp.blank?
      if @resp["status"] == "OK"
        @trip.origin_name = @resp["routes"][0]["legs"][0]["start_address"]
        @trip.destination_name = @resp["routes"][0]["legs"][-1]["end_address"]
        @trip.raw_response = @resp.to_json.to_s

        @trip.routes.destroy_all

        @resp["routes"].each do |route|
          @trip.routes.create({ :route_json => route, :trip_id => @trip })
        end

        @trip.save!
      else
        # @resp["status"] not OK, show error message
        flash.now[:alert] = route_status_error(@resp["status"])
      end
    end

    @json = JSON.parse(@trip.raw_response)

    puts @trip.routes.length
  end

  def edit
  end

  def update
    origin = params[:trip][:origin_name]
    destination = params[:trip][:destination_name]

    if @trip.valid?
      @resp = route_api_request(origin, destination)
    else
      flash.now[:alert] = "Origin and destination can't be blank. Please try again."
    end

    unless @resp.blank?
      if @resp["status"] == "OK"
        @trip.origin_name = @resp["routes"][0]["legs"][0]["start_address"]
        @trip.destination_name = @resp["routes"][0]["legs"][-1]["end_address"]
        @trip.raw_response = @resp.to_json.to_s

        if @trip.save!
          flash[:notice] = "Trip updated"
          redirect_to trip_path(@trip)
          return
        else
          flash.now[:alert] = "Trip not updated"
        end
      else
        flash.now[:alert] = route_status_error(@resp["status"])
      end
    end

    # didn't get to save for one of various reasons, send user back
    render 'edit'
  end

  def destroy
    @trip.destroy
    flash[:notice] = "Trip was deleted!"
    redirect_to trips_path
  end

  def save
    # return saved trip method
    # this action will trigger SAVING the trip for the current user.
    # in create, the trip is saved but not assigned a user
    # in order to edit, delete, etc, the trip must first be saved


    @trip.user = current_user
    @trip.save!

    flash[:notice] = "Your trip has been saved"
    redirect_to trip_path(@trip)
  end

  private

  def find_trip
    @trip = Trip.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Trip could not be found."
    redirect_to root_path
  end
end
