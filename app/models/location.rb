class Location < ActiveRecord::Base
  validates :lonlat, presence: true

  # Set/update 'lonlat' via the virtual attributes if they are set.
  before_validation do
    if [@lat, @lon].any? {|atr| atr.present? }
      @lat ||= lonlat.try(:y)
      @lon ||= lonlat.try(:x)
      self.lonlat = "POINT(#{@lon} #{@lat})"
    end
  end

  # Virtual Attributes for allowing setting lat/lon as separate attributes
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
