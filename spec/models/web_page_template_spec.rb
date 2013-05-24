require 'spec_helper'

describe WebPageTemplate do
  let(:web_page_template) { Fabricate.build(:web_page_template) }
  it "should be a WebTemplate" do
    web_page_template.should be_kind_of(WebTemplate)
  end
  it "should have a main section" do
    web_page_template.sections.should include "main"
  end
  it "should return all widgets" do
    web_page_template.all_widgets.should be_a(Array)
  end

  describe "WebPageTemplate default widgets" do
    before do
      WebPageTemplate.any_instance.unstub(:create_default_widgets)
      Widget.stub(build_widget_url: "spec/support/widget.html")
      WebHomeTemplate.any_instance.stub(default_widgets: ["storage-list"])
      @web_home_template = Fabricate(:web_home_template)
    end
    it "builds default widgets for WebPageTemplate subclasses" do
      @web_home_template.widgets.map(&:name).should include("Storage List")
    end
    it "assigns the widgets to the 'main' section" do
      @web_home_template.main_widgets.count.should ==
        @web_home_template.default_widgets.length
    end
  end
end
