require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  include ActionDispatch::TestProcess

  let(:latitude)  { '31.764845199999996' }
  let(:longitude) { '-115.19689439999999' }
  let(:valid_attributes) { { lonlat: "POINT(#{longitude} #{latitude})" } }
  let(:custom_origin) { LocationsController::GPS_Location.new( x: longitude, y: latitude ) }
  let(:invalid_attributes) { {} }

  describe "GET #index" do
    it "assigns all locations as @locations" do
      location = Location.create! valid_attributes
      get :index
      expect(assigns(:locations)).to eq([location])
    end
    context 'with custom origin' do
      it 'is used in place of the default location' do
        expect(Location).to receive(:with_and_by_distance_from_origin_in_miles).with(custom_origin)
        get :index, origin: "#{custom_origin.y}, #{custom_origin.x}"
      end
    end
  end

  describe "POST #upload" do
    context "with valid params" do
    let(:file) { fixture_file_upload('files/import-data.tsv', 'text/tsv') }
      it "creates a new Location for each record in file" do
        expect {
          post :upload, locations: {file: file}
        }.to change(Location, :count).by(2)
      end

      it "redirects to the index" do
        post :upload, locations: {file: file}
        expect(response).to redirect_to(locations_path)
      end
    end

    context "with invalid params" do
      it "redirects back to the index with alerts" do
        post :upload, locations: {}
        expect(flash.alert).to be_present
        expect(response).to be_unprocessable
      end
    end
  end
end
