require 'spec_helper'

describe TripsController do
  let(:user) { Factory(:confirmed_user) }
  let(:trip) { Factory(:bus_trip) }

  context "visitors" do
    before do
      trip.update_attribute(:user, user)
    end

    # visitors can create trips, but have no saved trips to edit, update, or delete
    # visitors must sign in to save a trip
    {
      "edit" => "get",
      "update" => "put",
      "destroy" => "delete",
      "save" => "get"
    }.each do |action, method|
      it "cannot access the #{action} action" do
        send method, action, :id => trip.id
        #current_url.should eql new_user_session_url

        flash[:alert].should have_content("You need to sign in or sign up before continuing")
      end
    end
  end

  context "standard users" do
    before do
      sign_in(:user, user)
    end

    # signed in users can CRUD trips that belong to them!
    # we need to scope Trips down to only the current_user's trips
  end

  context "admin users" do
    # admins can do anything
  end

  it "displays an error for a missing Trip" do
    # get :show, :id => "3482345928345"
    # response.should redirect_to root_path
    # message = "Trip could not be found."
  end
end
