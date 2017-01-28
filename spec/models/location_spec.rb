require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:latitude)  { '32.764845199999996' }
  let(:longitude) { '-117.19689439999999' }
  let(:location)  { Location.create(name: "Coffee Shop", lonlat: "POINT(#{longitude} #{latitude})") }
  subject { location }
  it { is_expected.to validate_presence_of(:lonlat) }
  describe '.coordinates' do
    subject { location.coordinates }
    it { is_expected.to eq "(#{latitude}, #{longitude})" }
  end
end
