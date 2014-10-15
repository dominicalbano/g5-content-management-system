require 'spec_helper'

describe AreaPageRenderer do
  let(:renderer) { described_class.new(Location.all, area) }
  let(:area) { "Or" }
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }

  describe "#render" do
    subject { renderer.render }

    describe "title" do
      context "state level" do
        it { is_expected.to include("Locations in OR") }
      end

      context "state and city level" do
        let(:area) { "Bend, Or" }

        it { is_expected.to include("Locations in Bend, OR") }
      end

      context "state, city and neighborhood level" do
        let(:area) { "West Side, Bend, Or" }

        it { is_expected.to include("Locations in West Side, Bend, OR") }
      end
    end

    it "includes the correct title" do
      expect(subject).to include("Locations in OR")
    end

    it "includes the location name" do
      expect(subject).to include(location.name)
    end

    it "includes the location street address" do
      expect(subject).to include(location.street_address.to_s)
    end

    it "includes the location city" do
      expect(subject).to include(location.city)
    end

    it "includes the location state" do
      expect(subject).to include(location.state)
    end

    it "includes the location postal code" do
      expect(subject).to include(location.postal_code.to_s)
    end
  end
end
