require 'spec_helper'

describe LocationCollector do
  let(:location_collector) { described_class.new(params) }
  let!(:state_location) { Fabricate(:location, state: "OR", status: "Live") }
  let!(:city_location) { Fabricate(:location, state: "OR", city: "Bend", status: "Live") }
  let!(:neighborhood_location) { Fabricate(:location, state: "OR", city: "Bend", neighborhood: "Foo", status: "Live") }

  describe "#collect" do
    subject { location_collector.collect }

    context "state level params" do
      let(:params) { { state: "or" } }

      it "contains all three locations" do
        expect(subject).to match_array([state_location, city_location, neighborhood_location])
      end
    end

    context "city level params" do
      let(:params) { { state: "or", city: "bend" } }

      it { is_expected.to match_array([city_location, neighborhood_location]) }
    end

    context "neighborhood level params" do
      let(:params) { { state: "or", city: "bend", neighborhood: "foo" } }

      it { should eq([neighborhood_location]) }
    end
  end
end
