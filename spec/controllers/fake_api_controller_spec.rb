require 'spec_helper'

describe FakeApiController do

  describe "GET 'json'" do
    it "returns http success" do
      get 'json'
      response.should be_success
    => end
  end

end
