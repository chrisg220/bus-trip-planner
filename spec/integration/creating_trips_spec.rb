require 'spec_helper'

feature "Creating Trips" do
  let(:bus_trip) { Factory.build(:bus_trip) }
  let(:no_results_trip) { Factory.build(:no_results_trip) }
  let(:not_found_trip) { Factory.build(:not_found_trip) }

  context "visitors" do
    before do
      visit "/"
      click_link "Create new trip"
    end

    scenario "can create Trip" do
      fill_in "trip[name]", :with => "A fun trip from CodeFellows to Discovery Park"
      fill_in "Starting Point", :with => bus_trip.origin_name
      fill_in "Ending Point", :with => bus_trip.destination_name
      click_button "Submit"

      within ".alert" do
        page.should have_content "Trip stored"
      end
    end

    scenario "can not create Trip with missing locations" do
      fill_in "Starting Point", :with => ""
      fill_in "Ending Point", :with => ""
      click_button "Submit"

      within ".alert" do
        page.should have_content "Origin and destination can't be blank"
      end

      page.should have_content "Starting point can't be blank"
      page.should have_content "Ending point can't be blank"
    end

    scenario "fail gracefully if Google can't find a route (no results)" do
      fill_in "Starting Point", :with => no_results_trip.origin_name
      fill_in "Ending Point", :with => no_results_trip.destination_name

      click_button "Submit"

      within ".alert" do
        page.should have_content "We couldn't find a route"
      end
    end

    scenario "fail gracefully if Google can't find the locations" do
      fill_in "Starting Point", :with => not_found_trip.origin_name
      fill_in "Ending Point", :with => not_found_trip.destination_name

      click_button "Submit"

      within ".alert" do
        page.should have_content "couldn't locate your origin and destination"
      end
    end

    scenario "fail gracefully when location is outside King County" do
      assert_
    end

    scenario "check that date is not in the past" do
      # http://stackoverflow.com/questions/1836000/how-to-validate-a-models-date-attribute-against-a-specific-range-evaluated-at
    end
  end

  context "registered users" do
    let!(:user) { Factory(:confirmed_user) }
    before do
      visit "/"
      click_link "Create new trip"
    end

    scenario "users have to sign in when saving trip" do
      fill_in "trip[name]", :with => "A fun trip from CodeFellows to Discovery Park"
      fill_in "Starting Point", :with => bus_trip.origin_name
      fill_in "Ending Point", :with => bus_trip.destination_name
      click_button "Submit"

      within ".alert" do
        page.should have_content "Trip stored"
      end

      click_link "Save Trip"

      page.should have_content "You need to sign in or sign up before continuing."

      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password

      click_button "Sign in"

      page.should have_content "Your trip has been saved"
    end

  end
end
