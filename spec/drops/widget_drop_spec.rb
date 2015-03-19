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
    its(:cpns_url) { should eq("//g5-cpns-12345-test.herokuapp.com/") }
    its(:secure_cpns_url) { should eq("//g5-cpns-12345-test.herokuapp.com/") }
  end

  describe "parent_widget_id" do
    before do
      website = Fabricate(:website)
      webtemplate = Fabricate(:web_template)
      website.web_templates << webtemplate
      webtemplate.drop_targets << Fabricate(:drop_target)
      row_garden_widget = Fabricate(:row_garden_widget)
      row_garden_widget.settings << Fabricate.build(:column_one_widget_name)
      row_garden_widget.settings << Fabricate.build(:column_one_widget_id)
      @widget = Fabricate(:widget, garden_widget: row_garden_widget, drop_target: webtemplate.drop_targets.first)
      @widget.settings.where(name: "column_one_widget_name").first.
        update_attributes(value: (Fabricate(:garden_widget).name))
    end

    it "returns the parent widget id if there is one" do
      WidgetDrop.new(Widget.last, client.try(:locations)).parent_widget_id.should eql(@widget.id)
    end
  end

  describe "#corporate_navigation" do
    let(:setting) { double(value: true) }

    before do
      CorporateNavigationSetting.stub(new: setting)
      drop.corporate_navigation
    end

    it "instantiates the corporate navigation setting class" do
      expect(CorporateNavigationSetting).to have_received(:new)
    end

    it "calls value on the setting class" do
      expect(setting).to have_received(:value)
    end
  end
end
