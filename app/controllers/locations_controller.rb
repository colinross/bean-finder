class LocationsController < ApplicationController
  # GET /locations
  def index
    @locations = Location.all
  end

  # POST /locations/upload
  def upload
    begin
    if upload_file.present?
      column_lookup = {address_1: "address_line_1", address_2: "address_line_2"}
      service = LocationImportService.new(opts: {column_attribute_lookup: column_lookup})
      result = service.perform(file: upload_file.try(:path))
    end
    rescue ActionController::ParameterMissing => e
      flash.alert = e.inspect
      redirect_to locations_path, status: :unprocessable_entity and return
    end
    respond_to do |format|
      if result.imported?
        format.html { redirect_to locations_path, notice: "#{result.records.count} Locations were successfully created." }
        format.json { redirect_to locations_path, status: :created }
      else
        format.html { redirect_to locations_path, alert: "Errors: #{result.errors.join(", ")}" }
        format.json { render json: service.try(:errors), status: :unprocessable_entity }
      end
    end
  end

  private
    def upload_file
      params.require(:locations).require(:file)
    end
end
