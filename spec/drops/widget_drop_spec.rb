require "spec_helper"

describe WidgetDrop do
  let!(:client) { Fabricate(:client, uid: "http://g5-hub.herokuapp.com/g5-c-12345-test") }
  let!(:location) { Fabricate(:location) }
  let!(:web_template) { Fabricate(:web_page_template) }
  let(:web_home_template) {Fabricate(:web_home_template)}
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

  describe "parent_widget_id" do
    before do
      website = Fabricate(:website)
      webtemplate = Fabricate(:web_template)
      website.web_templates << webtemplate
      webtemplate.drop_targets << Fabricate(:drop_target)
      row_garden_widget = Fabricate(:content_stripe_garden_widget)
      garden_widget = Fabricate(:garden_widget)
      @row_widget = Fabricate(:widget, garden_widget: row_garden_widget, drop_target: webtemplate.drop_targets.first)
      @child_widget = Fabricate(:widget, garden_widget: garden_widget )
      @row_widget.set_child_widget(1, @child_widget)
    end

    it "returns the parent widget id if there is one" do
      WidgetDrop.new(@child_widget, client.try(:locations)).parent_widget_id.should eql(@row_widget.id)
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

  describe "#navigateable_pages" do
    before do
      website = Fabricate(:website)
      website.web_templates << web_template
      website.web_home_template = web_home_template
    end
    it "returns a thing" do
      expected = [{"url" => web_template.url,
                   "preview_url" => web_template.preview_url,
                   "slug" => web_template.slug},
                  {"url" => web_home_template.url,
                   "preview_url" => web_home_template.preview_url,
                   "slug" => web_home_template.slug}]
      WidgetDrop.new(widget, client.try(:locations)).navigateable_pages.should eql(expected)
    end
  end

  describe "#generated urls"do 
    before do
      @web_template_2 = Fabricate(:web_page_template, name: web_template.name)
      website_2 = Fabricate(:website)
      website_2.web_templates << @web_template_2
      drop_target_2 = Fabricate(:drop_target, web_template: @web_template_2)

      website = Fabricate(:website)
      website.web_templates << web_template

      @cta_widget = Fabricate(:widget, drop_target: drop_target_2)

      allow(@cta_widget).to receive(:page_slug_1).and_return(double("value", {value: @web_template_2.slug}))
    end
    context "preview" do
      it "gets the preview url for the right page based on the slug in the setting" do
        WidgetDrop.new(@cta_widget, client.try(:locations), true).generated_url_1.should eql(@web_template_2.preview_url)
      end
    end
    context "production" do
      it "gets the production url for the right page based on the slug in the setting" do
        WidgetDrop.new(@cta_widget, client.try(:locations)).generated_url_1.should eql(@web_template_2.url)
      end
    end
  end
end

