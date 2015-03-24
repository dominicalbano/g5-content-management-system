require "spec_helper"

shared_examples_for SettingNavigation do
  before do
    fake_website = OpenStruct.new("navigateable_web_templates" => 
                                      [OpenStruct.new("id" => "1"), OpenStruct.new("id" => "2")])
    site_finder_instance = OpenStruct.new("find" => fake_website)
    allow(WebsiteFinder::Setting).to receive(:new).and_return(site_finder_instance)
  end
 
  let(:described_instance) do 
    described = described_class.new
    allow(described).to receive(:owner).and_return(Fabricate(:widget))
    described
  end

  describe "When display changes on widget" do
    let(:website_value) {{
        "1"=>{"display"=>true, "title"=>"Homepage", "url"=>"/homepage"},
        "2"=>{"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
      }}

    let(:widget_value) {{
      "1"=>{"display"=>false},
      "2"=>{"display"=>true}
      }}

    let(:expected_value) {{
        "1"=>{"display"=>false, "title"=>"Homepage", "url"=>"/homepage"},
        "2"=>{"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
      }}

    it "Keeps new display value" do
      described_instance.create_new_value(website_value, widget_value).should eq expected_value
    end
  end

  describe "When the title changes on website" do
    let(:widget_value) {
      {"1"=>{"display"=>"false", "title"=>"Old Title", "url"=>"/old-title"}}
    }
    let(:website_value) {
      {"1"=>{"display"=>"true", "title"=>"New Title", "url"=>"/new-title"},
       "2"=>{"display"=>"true", "title"=>"New Page", "url"=>"/new-page"}}
    }
    let(:expected_value) {{
      "1"=>{"display"=>"false", "title"=>"New Title", "url"=>"/new-title"},
      "2"=>{"display"=>"true", "title"=>"New Page", "url"=>"/new-page"}
      }}

    it "Keeps new title and old display value" do
      described_instance.create_new_value(website_value, widget_value).should eq expected_value
    end
  end

  context "child pages" do
    describe "When the child page is checked" do
      let(:widget_value) {
        {
          "1"=>{"display"=>"true", "title"=>"about", "url"=>"/about"},
          "2"=>{"display"=>"true", "title"=>"floorplans", "url"=>"/floorplans", "child_templates" => {
            "3"=>{"display"=>"true", "title"=>"child page", "url"=>"/old-title"}
            }
          }
        }
      }

      let(:website_value) {
        {
          "1"=>{"display"=>"true", "title"=>"about", "url"=>"/about"},
          "2"=>{"display"=>"true", "title"=>"floorplans", "url"=>"/floorplans", "child_templates" => {
            "3"=>{"display"=>false, "title"=>"child page", "url"=>"/old-title"}
            }
          }
        }
      }
      let(:expected_value) {
        {
          "1"=>{"display"=>"true", "title"=>"about", "url"=>"/about"},
          "2"=>{"display"=>"true", "title"=>"floorplans", "url"=>"/floorplans", "sub_nav" => "true", "child_templates" => {
            "3"=>{"display"=>"true", "title"=>"child page", "url"=>"/old-title"}
            }
          }
        }
      }

      it "sets display to true on the child page and sets a sub_nav property" do
        described_instance.create_new_value(website_value, widget_value).should eq expected_value
      end
    end

    describe "when the child page is unchecked" do
      let(:widget_value) {
        {
          "1"=>{"display"=>"true", "title"=>"about", "url"=>"/about"},
          "2"=>{"display"=>"true", "title"=>"floorplans", "url"=>"/floorplans", "child_templates" => {
            "3"=>{"display"=>"false", "title"=>"child page", "url"=>"/old-title"}
            }
          }
        }
      }

      let(:website_value) {
        {
          "1"=>{"display"=>"true", "title"=>"about", "url"=>"/about"},
          "2"=>{"display"=>"true", "title"=>"floorplans", "url"=>"/floorplans", "child_templates" => {
            "3"=>{"display"=>"true", "title"=>"child page", "url"=>"/old-title"}
            }
          }
        }
      }
      let(:expected_value) {
        {
          "1"=>{"display"=>"true", "title"=>"about", "url"=>"/about"},
          "2"=>{"display"=>"true", "title"=>"floorplans", "url"=>"/floorplans", "child_templates" => {
            "3"=>{"display"=>"false", "title"=>"child page", "url"=>"/old-title"}
            }
          }
        }
      }
      it "sets display to false on the child page and doesnt set sub_nav" do
        described_instance.create_new_value(website_value, widget_value).should eq expected_value
      end
    end
  end

end

describe Setting do
  it_behaves_like SettingNavigation
end

