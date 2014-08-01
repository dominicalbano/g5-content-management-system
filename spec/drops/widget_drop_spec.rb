require "spec_helper"

describe WidgetDrop do
  let!(:client) { Fabricate(:client) }
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
    let(:client_services) { double(cpns_url: "http://example.com/cpns") }
    before { allow(ClientServices).to receive(:new).and_return(client_services) }

    its(:cpns_url) { should eq("http://example.com/cpns") }
  end
end
