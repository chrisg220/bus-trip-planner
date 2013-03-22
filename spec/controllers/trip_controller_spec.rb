require 'spec_helper'

describe TripsController do

  context "visitors" do
    # visitors can create trips, but have no saved trips to edit, update, or delete
    # visitors must sign in to save a trip
    {
      "edit" => "get",
      "update" => "put",
      "destroy" => "delete",
      "save" => "post"
    }.each do |action, method|
      it "cannot access the #{action} action" do
        response.should redirect_to(root_path)
        flash[:alert].should eql("You must have an account to do that.")
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
    get :show, :id => "NaN"
    response.should redirect_to root_path
    message = "Trip could not be found."
    flash[:alert].shoud eql message
  end

  it "gets valid json from google" do
    VCR.use_cassette('google_directions_call') do
      get :create, { :trip => {:origin_name =>"511 boren ave n seattle wa",
                   :destination_name => "1100 17th ave seattle wa" }}
      response.status.should == 200
    end
  end

end
