require 'spec_helper'

describe WebPageTemplate do
  let(:web_page_template) { Fabricate.build(:web_page_template) }

  it "should be a WebTemplate" do
    web_page_template.should be_kind_of(WebTemplate)
  end

  it "should return all widgets" do
    web_page_template.all_widgets.should be_a(Array)
  end

  describe "#compile_path" do
    let(:location) { Fabricate(:location) }
    let(:website) { Fabricate(:website, owner: location) }
    let(:web_page_template) { Fabricate(:web_page_template, website_id: website.id) }
    let!(:client) { Fabricate(:client) }

    before do
      web_page_template.stub(:update_navigation_settings)
    end  

    it "includes slug" do
      web_page_template.compile_path.should include web_page_template.slug
    end
  end
end
