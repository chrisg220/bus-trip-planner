require 'spec_helper'

feature "Creating Trips" do
  scenario "can create Trip" do
    visit "/"
    click_link "Create new trip"
  end
end
