require 'spec_helper'

feature "Creating Trips" do

  before do
    visit "/"
    click_link "Create new trip"
  end

  scenario "can create Trip" do
    fill_in "trip[name]", :with => "A fun trip from CodeFellows to the Airport"
    fill_in "Starting Point", :with => "511 Boren Ave N, Seattle WA"
    fill_in "Ending Point", :with => "SeaTac, WA"
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

    # page.should have_content "Starting point can't be blank"
    # page.should have_content "Ending point can't be blank"
  end

  scenario "fail gracefully if Google can't find a route" do
    fill_in "Starting Point", :with => "511 Boren Ave"
    fill_in "Ending Point", :with => "Washington, DC"

    click_button "Submit"

    within ".alert" do
      page.should have_content "We couldn't find a route"
    end
  end

  scenario "fail gracefully if Google can't find the locations" do
    fill_in "Starting Point", :with => "Whoville"
    fill_in "Ending Point", :with => "Washington, DC"

    click_button "Submit"

    within ".alert" do
      page.should have_content "couldn't locate your origin and destination"
    end
  end

  scenario "fail gracefully when location is outside King County" do
    #
  end

  scenario "check that date is not in the past" do
    # http://stackoverflow.com/questions/1836000/how-to-validate-a-models-date-attribute-against-a-specific-range-evaluated-at
  end
end
