require 'spec_helper'

describe WidgetsController, vcr: VCR_OPTIONS do
  let(:page) { Fabricate(:web_template) }
  let(:widget) { Fabricate(:widget, web_template: page) }

  before do
    Widget.stub(:find) { widget }
  end

  it_should_behave_like 'a secure controller'

  context "when there is an authenticated user", :auth_controller do
    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit', id: 1
        response.should be_success
      end
    end

    describe "PUT update" do

    it "returns the last updated widget with date only" do
      widget.stub(:update_attributes) { true }
      expect(page.last_mod).to eq(widget.updated_at.to_date)
    end

    describe "HTML" do
      let(:update) { put :update, id: 1, widget: { username: "Bookis" } }

        it "returns a 204 on success" do
          widget.stub(:update_attributes) { true }
          update
          response.status.should eq 302
        end

        it "returns 422 on fail" do
          widget.stub(:update_attributes) { false }
          update
          response.should render_template :edit
        end

        it "returns the error messages on fail" do
          widget.stub(:update_attributes) { widget.errors[:base] << "There was an error" }
          update
          assigns(:widget).errors[:base].should include "There was an error"
        end
      end

      describe "JSON" do
        let(:setting) { widget.settings.create(name: "Feed") }
        let(:update) { put :update, id: 1, widget: { settings_attributes: {id: setting.id, value: "Bookis"}}, format: :json }

        it "attempts to update configurations" do
          widget.should_receive(:update_attributes).once.with({"settings_attributes" => {"id" => setting.id, "value" => "Bookis"}})
          update
        end

        it "returns a 204 on success" do
          widget.stub(:update_attributes) { true }
          update
          response.status.should eq 204
        end

        it "returns 422 on fail" do
          widget.stub(:update_attributes) { false }
          update
          response.status.should eq 422
        end

        it "returns the error messages on fail" do
          widget.stub(:update_attributes) { widget.errors[:base] << "There was an error"; false }
          update
          JSON.parse(response.body).should eq({"errors" => {"base" => ["There was an error"]}})
        end
      end
    end
  end
end
