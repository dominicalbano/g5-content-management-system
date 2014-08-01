require "spec_helper"

describe WidgetDrop do
  let!(:client) { Fabricate(:client, uid: "http://g5-hub.herokuapp.com/g5-c-12345-test") }
  let!(:location) { Fabricate(:location) }
  let!(:web_template) { Fabricate(:web_template) }
  let(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
  let(:widget) { Fabricate(:widget, drop_target: drop_target) }
  subject(:drop) { described_class.new(widget, [location]) }

  describe "#client_locations" do
    subject(:first_location) { drop.client_locations.first }

    it "decorates a location" do
      expect(first_location).to be_kind_of(LocationDecorator)
    end
  end

  describe "service URL helpers" do
    its(:cpns_url) { should eq("http://g5-cpns-12345-test.herokuapp.com/") }
    its(:secure_cpns_url) { should eq("https://g5-cpns-12345-test.herokuapp.com/") }
  end
end
