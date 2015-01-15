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

  describe "Fonts" do
    describe "Default Fonts" do
      describe "When custom fonts are nil" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_fonts: nil,
          custom_primary_font: nil,
          custom_secondary_font: nil) }

        it { web_theme.primary_font.should eq(web_theme.garden_web_theme_primary_font) }
        it { web_theme.secondary_font.should eq(web_theme.garden_web_theme_secondary_font) }
      end

      describe "When custom fonts are present" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_fonts: nil,
          custom_primary_font: "#custom-primary",
          custom_secondary_font: "#custom-secondary" ) }

        it { web_theme.primary_font.should eq(web_theme.garden_web_theme_primary_font) }
        it { web_theme.secondary_font.should eq(web_theme.garden_web_theme_secondary_font) }
      end
    end

    describe "Custom Fonts" do
      describe "When custom fonts are nil" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_fonts: true,
          custom_primary_font: nil,
          custom_secondary_font: nil) }

        it { web_theme.primary_font.should eq(web_theme.garden_web_theme_primary_font) }
        it { web_theme.secondary_font.should eq(web_theme.garden_web_theme_secondary_font) }
      end

      describe "When custom fonts are present" do
        let(:web_theme) { Fabricate(:web_theme,
          custom_fonts: true,
          custom_primary_font: "#custom-primary",
          custom_secondary_font: "#custom-secondary" ) }

        it { web_theme.primary_font.should eq "#custom-primary" }
        it { web_theme.secondary_font.should eq "#custom-secondary" }
      end
    end
  end
end
