require "spec_helper"

describe CorporateMapSetting do
  let!(:location_2) { Fabricate(:location, state: "CA", city: "San Francisco", status: "Live") }
  let!(:location_3) { Fabricate(:location, state: "OR", status: "Live") }
  let!(:location_1) { Fabricate(:location, state: "CA", city: "Los Angeles", status: "Live") }
  let!(:location_4) { Fabricate(:location, state: "CA", city: "San Diego", status: "Pending") }
  let!(:location_5) { Fabricate(:location, state: "CA", city: "Chico", status: "Pending") }

  describe "#value" do
    subject { CorporateMapSetting.new.value }

    describe "location values" do
      let!(:corporate_location) do
        Fabricate(:location, state: "WA", corporate: true, status: "Live")
      end

      it "displays the correct populated_states" do
        expect(subject["populated_states"]).to eq("[\"CA\",\"OR\"]")
      end

      it "displays the correct state_location_counts" do
        expect(subject["state_location_counts"]).to eq("{\"CA\":2,\"OR\":1}")
      end
    end

    describe "colors" do
      context "no corporate defined location" do
        it "displays the default primary color" do
          expect(subject["primary_color"]).to eq("\"#222222\"")
        end

        it "displays the default hover color" do
          expect(subject["hover_color"]).to eq("\"#333333\"")
        end
      end

      context "a corporate defined location" do
        let!(:corporate) { Fabricate(:location, corporate: true) }
        let!(:website) { Fabricate(:website, owner: corporate, website_template: web_template) }
        let!(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
        let!(:garden_web_theme) { Fabricate(:garden_web_theme, primary_color: "#000000") }
        let!(:web_template) { Fabricate(:website_template, web_theme: web_theme) }

        context "no custom web_theme colors" do
          it "displays the default primary color" do
            expect(subject["primary_color"]).to eq("\"#000000\"")
          end

          it "displays the default hover color" do
            expect(subject["hover_color"]).to eq("\"#2b2b2b\"")
          end
        end

        context "custom web_theme colors" do
          let!(:web_theme) do
            Fabricate(:web_theme, custom_primary_color: "#FF66FF", garden_web_theme: garden_web_theme)
          end

          it "displays the custom primary color" do
            expect(subject["primary_color"]).to eq("\"#FF66FF\"")
          end

          it "displays the custom hover color" do
            expect(subject["hover_color"]).to eq("\"#ff91ff\"")
          end
        end
      end
    end
  end
end
