json.extract! location, :id, :name, :address_line_1, :address_line_2, :postal_code_name, :postal_code_suffix, :phone_number, :radius, :coordinates, :created_at, :updated_at
json.distance_from_origin location.distance
