require 'spec_helper'

feature "Viewing Trips" do
  let!(:trip) { Factory(:bus_trip) }

  before do
    visit "/"
  end

  scenario "can view trips" do
  end
end
