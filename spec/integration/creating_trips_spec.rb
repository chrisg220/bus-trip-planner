require 'spec_helper'

feature "Creating Trips" do

  before do
    visit "/"

    click_link "Create new trip"
  end

  scenario "can create Trip" do
    fill_in "trip[name]", :with => "A fun trip from CodeFellows to Northgate Mall"
    fill_in "Starting Point", :with => "511 Boren Ave N 98101"
    fill_in "Ending Point", :with => "Northgate Mall Seattle WA"
    click_button "Submit"

    page.should have_content "Trip stored"
  end

  scenario "can not create Trip with missing locations" do
    fill_in "Starting Point", :with => ""
    fill_in "Ending Point", :with => ""
    click_button "Submit"

    page.should have_content "Trip not stored"
    page.should have_content "Starting point can't be blank"
    page.should have_content "Ending point can't be blank"
  end

  scenario "fail gracefully if Google can't find a route" do
    fill_in "Starting Point", :with => "Timbuktu"
    fill_in "Ending Point", :with => "The North Pole"

    click_button "Submit"

    page.should have_content "Trip not stored"
    page.should have_content "We could not find a route between these locations"
  end

  scenario "fail gracefully when location is outside King County" do
    #
  end

  scenario "check that date is not in the past" do
    # http://stackoverflow.com/questions/1836000/how-to-validate-a-models-date-attribute-against-a-specific-range-evaluated-at
  end
end
