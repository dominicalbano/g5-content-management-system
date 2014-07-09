require "spec_helper"

shared_examples_for HasSettingNavigation do
  let!(:client) { Fabricate(:client) }
  let(:described_instance) { described_class.new }

  describe "#navigation_settings" do
    context "navigation setting exists" do
      let(:navigation) { described_instance.settings.build(name: "navigation") }
      it "finds setting with name navigation" do
        described_instance.save
        navigation.save
        described_instance.navigation_settings.should be_present
      end
    end
    context "navigation setting does not exist" do
      it "initializes setting with name navigation" do
        described_instance.save
        described_instance.navigation_settings.should be_present
      end
    end
  end

  describe "#navigateable_web_templates_to_hashes" do
    context "has no web pages" do
      it "returns an empty Hash" do
        described_instance.navigateable_web_templates_to_hashes.should eq({})
      end
    end

    context "has web pages" do
      let!(:web_page_template) { Fabricate(:web_page_template, website: described_instance) }
      let(:result) { described_instance.navigateable_web_templates_to_hashes }

      it "uses web template id string as key" do
        result.keys.first.should eq web_page_template.id.to_s
      end

      it "returns hashes with to liquid defined" do
        result.values.sample.should be_a(HashWithToLiquid)
      end

      it "hashes have key 'display'" do
        result.values.first["display"].should_not be_nil
      end

      it "hashes have key 'name'" do
        result.values.sample["name"].should_not be_nil
      end

      it "hashes have key 'url'" do
        result.values.sample["url"].should_not be_nil
      end

      describe "child templates" do
        let(:child_templates) { result.first[1]["child_templates"] }
        let(:first_child) { child_templates.first }

        context "no child pages" do
          it "has an empty array of child templates" do
            expect(child_templates).to be_empty
          end
        end

        context "a top level page with child pages" do
          let!(:child_template) do
            Fabricate(:web_template, website: described_instance, parent_id: web_page_template.id)
          end

          it "has an array of child templates" do
            expect(child_templates).to_not be_empty
          end

          it "populates a child display" do
            expect(first_child["display"]).to eq(child_template.display)
          end

          it "populates a child name" do
            expect(first_child["name"]).to eq(child_template.name)
          end

          it "populates a child url" do
            expect(first_child["url"]).to eq(child_template.url)
          end

          it "populates a child top_level" do
            expect(first_child["top_level"]).to eq(child_template.top_level)
          end

          it "populates a child child_template?" do
            expect(first_child["child_template?"]).to be_true
          end

          it "populates a child child_templates" do
            expect(first_child["child_templates"]).to eq(child_template.child_templates)
          end
        end
      end
    end
  end
end

describe Website do
  it_behaves_like HasSettingNavigation
end
