class Location < ActiveRecord::Base
  validates :lonlat, presence: true

  def coordinates
    "(#{lonlat.y}, #{lonlat.x})"
  end
end
