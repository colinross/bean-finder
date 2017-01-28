class Location < ActiveRecord::Base
  validates :lonlat, presence: true
end
