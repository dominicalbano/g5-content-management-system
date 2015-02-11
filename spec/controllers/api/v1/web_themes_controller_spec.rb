require "spec_helper"

describe Api::V1::WebThemesController, :auth_controller, vcr: VCR_OPTIONS do
  let(:web_theme) { Fabricate(:web_theme) }

  describe "#show" do
    it "finds web_theme" do
      WebTheme.should_receive(:find).with(web_theme.id.to_s).once
      get :show, id: web_theme.id
    end

    it "renders web_theme as json" do
      get :show, id: web_theme.id
      expect(response.body).to eq WebThemeSerializer.new(web_theme).to_json
    end
  end

  describe "#update" do
    context "when update_attributes succeeds" do
      before do
        WebTheme.any_instance.stub(:update_attributes) { true }
      end

      it "responds 200 OK" do
        put :update, id: web_theme.id, web_theme: { name: "lol" }
        expect(response.status).to eq 200
      end

      it "renders web_theme as json" do
        put :update, id: web_theme.id, web_theme: { name: "lol" }
        expect(response.body).to eq WebThemeSerializer.new(web_theme).to_json
      end
    end

    context "when update_attributes fails" do
      before do
        WebTheme.any_instance.stub(:update_attributes) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        put :update, id: web_theme.id, web_theme: { name: "lol" }
        expect(response.status).to eq 422
      end


      it "renders web_theme errors as json" do
        put :update, id: web_theme.id, web_theme: { name: "lol" }
        expect(response.body).to eq "{}"
      end
    end

    context "allowed attributes" do
      it "garden_web_theme_id" do
        put :update, id: web_theme.id, web_theme: { garden_web_theme_id: 333 }
        expect(response.status).to eq 200
        expect(web_theme.reload.garden_web_theme_id).to eq 333
      end

      it "custom_colors" do
        put :update, id: web_theme.id, web_theme: { custom_colors: true }
        expect(response.status).to eq 200
        expect(web_theme.reload.custom_colors).to eq true
      end

      it "primary_color" do
        put :update, id: web_theme.id, web_theme: { primary_color: "#custom-color" }
        expect(response.status).to eq 200
        expect(web_theme.reload.custom_primary_color).to eq "#custom-color"
      end

      it "secondary_color" do
        put :update, id: web_theme.id, web_theme: { secondary_color: "#custom-color" }
        expect(response.status).to eq 200
        expect(web_theme.reload.custom_secondary_color).to eq "#custom-color"
      end

      it "tertiary_color" do
        put :update, id: web_theme.id, web_theme: { tertiary_color: "#custom-color" }
        expect(response.status).to eq 200
        expect(web_theme.reload.custom_tertiary_color).to eq "#custom-color"
      end

      it "custom_fonts" do
        put :update, id: web_theme.id, web_theme: { custom_fonts: true }
        expect(response.status).to eq 200
        expect(web_theme.reload.custom_fonts).to eq true
      end

      context "primary_font" do
        it "returns custom primary font when use custom fonts is true" do
          put :update, id: web_theme.id, web_theme: { custom_fonts: true, primary_font: "#custom-font" }
          expect(response.status).to eq 200
          expect(web_theme.reload.primary_font).to eq "#custom-font"
        end

        it "returns default primary font when use custom fonts is false" do
          put :update, id: web_theme.id, web_theme: { custom_fonts: false, primary_font: "#custom-font" }
          expect(response.status).to eq 200
          expect(web_theme.reload.primary_font).to eq "PT Sans"
        end
      end

      context "secondary_font" do
        it "returns custom secondary font when use custom fonts is true" do
          put :update, id: web_theme.id, web_theme: { custom_fonts: true, secondary_font: "#custom-font" }
          expect(response.status).to eq 200
          expect(web_theme.reload.secondary_font).to eq "#custom-font"
        end

        it "returns default secondary font when use custom fonts is false" do
          put :update, id: web_theme.id, web_theme: { custom_fonts: false, secondary_font: "#custom-font" }
          expect(response.status).to eq 200
          expect(web_theme.reload.secondary_font).to eq "Georgia"
        end
      end
    end
  end
end
