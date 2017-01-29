class Location < ActiveRecord::Base
  SRID = 4326 # World_Geodetic_System#WGS84
  # I would suggest something like https://github.com/halogenandtoast/alchemist if we go much further than this
  METERS_IN_A_MILE = 1609.344
  MILES_IN_A_METER = 0.000621371

  validates :lonlat, presence: true

  # Set/update 'lonlat' via the virtual attributes if they are set.
  before_validation do
    if [@lat, @lon].any? {|atr| atr.present? }
      @lat ||= lonlat.try(:y)
      @lon ||= lonlat.try(:x)
      self.lonlat = "POINT(#{@lon} #{@lat})"
    end
  end

  def self.with_and_by_distance_from_origin_in_miles(origin)
    select("#{Location.table_name}.*, ST_Distance(lonlat, ST_GeomFromText('POINT (#{origin.x} #{origin.y})', #{SRID})) * #{MILES_IN_A_METER}  AS distance").
     # where("ST_DWithin(#{Location.table_name}.lonlat, ST_Geomfromtext('POINT (#{origin.x} #{origin.y})', #{SRID}), #{distance_in_meters})").
    order("distance ASC")
  end

  # Virtual Attributes to allow setting lat/lon as separate attributes
  def latitude=(v)
    @lat = v
  end

  def longitude=(v)
    @lon = v
  end

  def coordinates
    "(#{lonlat.y}, #{lonlat.x})"
  end
end
