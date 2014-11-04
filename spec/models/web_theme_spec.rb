require "spec_helper"

describe WebTheme, vcr: VCR_OPTIONS do
  describe "Colors" do
    describe "Default Colors" do
      describe "When custom colors are nil" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_colors: nil,
          custom_primary_color: nil,
          custom_secondary_color: nil,
          custom_tertiary_color: nil) }

        it { web_theme.primary_color.should eq(web_theme.garden_web_theme_primary_color) }
        it { web_theme.secondary_color.should eq(web_theme.garden_web_theme_secondary_color) }
        it { web_theme.tertiary_color.should eq(web_theme.garden_web_theme_tertiary_color) }
      end

      describe "When custom colors are present" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_colors: nil,
          custom_primary_color: "#custom-primary",
          custom_secondary_color: "#custom-secondary",
          custom_tertiary_color: "#custom-tertiary") }

        it { web_theme.primary_color.should eq(web_theme.garden_web_theme_primary_color) }
        it { web_theme.secondary_color.should eq(web_theme.garden_web_theme_secondary_color) }
        it { web_theme.tertiary_color.should eq(web_theme.garden_web_theme_tertiary_color) }
      end
    end

    describe "Custom Colors" do
      describe "When custom colors are nil" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_colors: true,
          custom_primary_color: nil,
          custom_secondary_color: nil,
          custom_tertiary_color: nil) }

        it { web_theme.primary_color.should eq(web_theme.garden_web_theme_primary_color) }
        it { web_theme.secondary_color.should eq(web_theme.garden_web_theme_secondary_color) }
        it { web_theme.tertiary_color.should eq(web_theme.garden_web_theme_tertiary_color) }
      end

      describe "When custom colors are present" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_colors: true,
          custom_primary_color: "#custom-primary",
          custom_secondary_color: "#custom-secondary",
          custom_tertiary_color: "#custom-tertiary") }

        it { web_theme.primary_color.should eq "#custom-primary" }
        it { web_theme.secondary_color.should eq "#custom-secondary" }
        it { web_theme.tertiary_color.should eq "#custom-tertiary" }
      end
    end
  end
end
