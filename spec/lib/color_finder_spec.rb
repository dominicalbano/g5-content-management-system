require "spec_helper"

describe ColorFinder do
  let(:color_finder) { described_class.new(location) }
  let(:location) { nil }
  let!(:website) { Fabricate(:website, owner: location, website_template: web_template) }
  let!(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let!(:garden_web_theme) { Fabricate(:garden_web_theme, primary_color: "#000000") }
  let!(:web_template) { Fabricate(:website_template, web_theme: web_theme) }

  describe "#primary_color" do
    subject { color_finder.primary_color }

    context "no defined location" do
      it { is_expected.to eq("#222222") }
    end

    context "a defined location" do
      let!(:location) { Fabricate(:location, corporate: true) }

      context "no custom web_theme colors" do
        it "displays the default primary color" do
          expect(subject).to eq("#000000")
        end
      end

      context "custom web_theme colors" do
        let!(:web_theme) do
          Fabricate(:web_theme, custom_primary_color: "#FF66FF", garden_web_theme: garden_web_theme)
        end

        it "displays the custom primary color" do
          expect(subject).to eq("#FF66FF")
        end
      end
    end
  end

  describe "#hover_color" do
    subject { color_finder.hover_color }

    context "no defined location" do
      it { is_expected.to eq("#333333") }
    end

    context "a defined location" do
      let!(:location) { Fabricate(:location, corporate: true) }

      context "no custom web_theme colors" do
        it "displays the default hover color" do
          expect(subject).to eq("#2b2b2b")
        end
      end

      context "custom web_theme colors" do
        let!(:web_theme) do
          Fabricate(:web_theme, custom_primary_color: "#FF66FF", garden_web_theme: garden_web_theme)
        end

        it "displays the custom hover color" do
          expect(subject).to eq("#ff91ff")
        end
      end
    end
  end
end
