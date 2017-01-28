require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  let(:latitude)  { '32.764845199999996' }
  let(:longitude) { '-117.19689439999999' }
  let(:valid_attributes) { { lonlat: "POINT(#{longitude} #{latitude})" } }
  let(:invalid_attributes) { {} }

  describe "GET #index" do
    it "assigns all locations as @locations" do
      location = Location.create! valid_attributes
      get :index
      expect(assigns(:locations)).to eq([location])
    end
  end
end
