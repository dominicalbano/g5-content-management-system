require 'spec_helper'

describe LocationCollector do
  let(:location_collector) { described_class.new(params) }
  let!(:state_location) { Fabricate(:location, state: "Oregon") }
  let!(:city_location) { Fabricate(:location, state: "Oregon", city: "Bend") }
  let!(:neighborhood_location) { Fabricate(:location, state: "Oregon", city: "Bend", neighborhood: "Foo") }

  describe "#collect" do
    subject { location_collector.collect }

    context "state level params" do
      let(:params) { { state: "oregon" } }

      it { should eq([state_location, city_location, neighborhood_location]) }
    end

    context "city level params" do
      let(:params) { { state: "oregon", city: "bend" } }

      it { should eq([city_location, neighborhood_location]) }
    end

    context "neighborhood level params" do
      let(:params) { { state: "oregon", city: "bend", neighborhood: "foo" } }

      it { should eq([neighborhood_location]) }
    end
  end
end
