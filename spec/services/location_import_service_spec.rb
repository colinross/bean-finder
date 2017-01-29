require 'rails_helper'

RSpec.describe LocationImportService do
  include ActionDispatch::TestProcess
  let(:file) { fixture_file_upload('files/import-data.tsv', 'text/tsv') }
  subject { LocationImportService.new }

  describe '#new' do
    it { is_expected.to be_a LocationImportService }
    it { expect(subject.opts).to eql({}) }
    it 'allows opts' do
      opts = {some_key: "some value"}
      service = LocationImportService.new(opts: opts)
      expect(service.opts[:some_key]).to eq "some value"
    end
  end
  describe '.perform' do
    let(:columns) { { address_1: "address_line_1", address_2: "address_line_2" } }
    let(:service) { LocationImportService.new(opts: {column_attribute_lookup: columns}) }
    subject { service.perform(file: file.path) }
    it { is_expected.to be_a LocationImportService::Result }
    it { is_expected.to be_imported }
    it { expect(subject.records.count).to eql 2 }
  end
  describe '.column_name_for' do
    let(:columns) { {address_1: "address_line_1", "zip": "postal_code" } }
    let(:service) { LocationImportService.new(opts: {column_attribute_lookup: columns}) }
    it "returns given key if column doesn't exist in lookup" do
      expect(service.send(:column_name_for, "city")).to eql "city"
    end
    it "returns found lookup key if column name exists in lookup" do
      expect(service.send(:column_name_for, "address_1")).to eql "address_line_1"
      expect(service.send(:column_name_for, "zip")).to eql "postal_code"
    end
  end
end
