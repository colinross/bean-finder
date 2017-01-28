json.extract! location, :id, :name, :address_line_1, :address_line_2, :postal_code_name, :postal_code_suffix, :phone_number, :radius_in_miles, :coordinates, :created_at, :updated_at
json.url location_url(location, format: :json)
