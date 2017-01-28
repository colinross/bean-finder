require "rails_helper"

RSpec.describe LocationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/locations").to route_to("locations#index")
    end

  end
end
