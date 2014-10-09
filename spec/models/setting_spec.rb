require 'spec_helper'

describe Setting, vcr: VCR_OPTIONS do
  describe "#validation" do
    let(:setting) { Setting.create }
    it "must have a name" do
      setting.errors[:name].should include "can't be blank"
    end

    it "must belong to a owner" do
      setting.errors[:owner].should include "can't be blank"
    end
  end

  describe "#categories" do
    let(:setting) { Fabricate(:setting) }
    it "is an Array" do
      setting.reload
      setting.categories.should be_an_instance_of Array
    end
  end

  # describe "#collection?" do
  #   let(:collection_setting) { Fabricate(:setting, categories: ["collection"]) }
  #   let(:instance_setting) { Fabricate(:setting, categories: ["instance"]) }

  #   it "returns true when categories includes collection" do
  #     collection_setting.collection?.should be_truthy
  #   end
  #   it "returns false when categories doesn't includes collection" do
  #     instance_setting.collection?.should be_falsey
  #   end
  # end

  describe "#best_value" do
    let(:web_template) { Fabricate.build(:web_template) }
    let(:web_template_setting) { Fabricate.build(:setting, name: "same_name") }
    let(:website) { Fabricate.build(:website) }
    let(:website_setting) { Fabricate.build(:setting, name: "same_name") }
    let(:client_setting) { Fabricate.build(:setting, name: "same_name") }

    before do
      web_template.settings << web_template_setting
      website.web_templates << web_template
      website.settings << website_setting
    end

    context "my value is present" do
      before do
        web_template_setting.value = "web template value"
        website_setting.value = "website value"
        client_setting.value = "client value"
        website.save
        client_setting.save
      end

      it "returns my value" do
        web_template_setting.best_value.should eq "web template value"
      end
    end

    context "lower priority and global settings are present" do
      before do
        website_setting.value = "website value"
        client_setting.value = "client value"
        website.save
        client_setting.save
      end

      it "returns lower priority setting value" do
        web_template_setting.best_value.should eq "website value"
      end
    end

    context "only global setting is present" do
      before do
        client_setting.value = "client value"
        website.save
        client_setting.save
      end

      it "returns global setting value" do
        web_template_setting.best_value.should eq "client value"
      end
    end
  end

  describe "#global_others" do
    let(:web_template_setting) { Fabricate(:setting, name: "same", website_id: 1) }
    let(:website_setting) { Fabricate(:setting, name: "same", website_id: 1) }

    describe "when name is the same and value is nil" do
      let!(:client_setting) { Fabricate(:setting, name: "same", website_id: nil, value: nil) }

      it "does not return setting without a website id" do
        web_template_setting.global_others.to_a.should eq []
      end
    end

    describe "when name is the same and value is present" do
      let!(:client_setting) { Fabricate(:setting, name: "same", website_id: nil, value: "not nil") }

      it "returns settings without a website id" do
        web_template_setting.global_others.to_a.should eq [client_setting]
      end
    end
  end

  describe "#others_with_higher_priority" do
    let(:setting0) { Fabricate(:setting, name: "same", value: "0", priority: 0) }
    let(:setting1) { Fabricate(:setting, name: "same", value: "1", priority: 1) }
    let(:setting2) { Fabricate(:setting, name: "same", value: "2", priority: 2) }

    it "returns empty when no others" do
      setting0.others_with_higher_priority.should be_empty
    end

    it "returns one when one other" do
      setting1.others_with_higher_priority.should eq [setting0]
    end

    it "returns two when two others" do
      setting2.others_with_higher_priority.should eq [setting1, setting0]
    end
  end

  describe "#others_with_lower_priority" do
    let(:setting0) { Fabricate(:setting, name: "same", value: "0", priority: 0) }
    let(:setting1) { Fabricate(:setting, name: "same", value: "1", priority: 1) }
    let(:setting2) { Fabricate(:setting, name: "same", value: "2", priority: 2) }

    it "returns one when one other" do
      setting2.others_with_lower_priority.should eq [setting2]
    end

    it "returns two when two others" do
      setting1.others_with_lower_priority.should eq [setting1, setting2]
    end

    it "returns three when three others" do
      setting0.others_with_lower_priority.should eq [setting0, setting1, setting2]
    end
  end

  # describe "#merge_value_with_lower_priority" do
  #   let(:setting0) { Fabricate(:setting, name: "same", priority: 0,
  #   value: {"0"=>{"display"=>false}}
  #   )}
  #   let(:setting1) { Fabricate(:setting, name: "same",
  #     value: [
  #       {"display"=>true, "title"=>"Homepage", "url"=>"/homepage"},
  #       {"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
  #     ]
  #   )}
  #   let(:expected_value) {[
  #     {"display"=>false, "title"=>"Homepage", "url"=>"/homepage"},
  #     {"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
  #   ]}
  #   it "does the expected thing" do
  #     setting0.merge_value_with_lower_priority(setting1).value.should eq expected_value
  #   end
  # end

  # describe "#merge_value_with_lower_priority" do
  #   let(:setting0) { Fabricate(:setting, name: "same", priority: 0,
  #     value: [
  #       {"display"=>false, "title"=>"Homepage", "url"=>"/homepage"},
  #     ]
  #   )}
  #   let(:setting1) { Fabricate(:setting, name: "same",
  #     value: [
  #       {"display"=>true, "title"=>"Homepage", "url"=>"/homepage"},
  #       {"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
  #     ]
  #   )}
  #   let(:expected_value) {[
  #     {"display"=>false, "title"=>"Homepage", "url"=>"/homepage"},
  #     {"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
  #   ]}
  #   it "does the expected thing" do
  #     setting0.merge_value_with_lower_priority(setting1).value.should eq expected_value
  #   end
  # end

  # describe "#merge_value_with_lower_priority" do
  #   let(:setting0) { Fabricate(:setting, name: "same",
  #     value: [
  #       {"display"=>false, "title"=>"Old Title", "url"=>"/old-title"},
  #     ]
  #   )}
  #   let(:setting1) { Fabricate(:setting, name: "same",
  #     value: [
  #       {"display"=>true, "title"=>"New Title", "url"=>"/new-title"},
  #       {"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
  #     ]
  #   )}
  #   let(:expected_value) {[
  #     {"display"=>false, "title"=>"New Title", "url"=>"/new-title"},
  #     {"display"=>true, "title"=>"New Page", "url"=>"/new-page"}
  #   ]}
  #   it "only updates display" do
  #     setting0.merge_value_with_lower_priority(setting1).value.should eq expected_value
  #   end
  # end
end
