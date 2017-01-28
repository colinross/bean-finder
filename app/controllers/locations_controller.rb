class LocationsController < ApplicationController
  # GET /locations
  def index
    @locations = Location.all
  end
end
