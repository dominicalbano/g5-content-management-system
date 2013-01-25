require 'spec_helper'

describe WidgetsController do
  let(:page) { Fabricate(:page) }
  let(:widget) { Fabricate(:widget, page: page) }
  before do
    Widget.stub(:find) { widget }
    Page.any_instance.stub(:location) { Fabricate(:location_without_pages) }
  end
  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', id: 1
      response.should be_success
    end
  end
  describe "PUT update" do
    
    describe "HTML" do
      let(:update) { put :update, id: 1, widget: { username: "Bookis" } }
      it "attempts to update configurations" do
        widget.should_receive(:update_configuration).once.with({"username" => "Bookis"})
        update
      end
      it "returns a 204 on success" do
        widget.stub(:update_configuration) { true }
        update
        response.status.should eq 302
      end
      it "returns 422 on fail" do
        widget.stub(:update_configuration) { false }
        update
        response.should render_template :edit
      end
      it "returns the error messages on fail" do
        widget.stub(:update_configuration) { widget.errors[:base] << "There was an error" }
        update
        assigns(:widget).errors[:base].should include "There was an error"
      end
      
    end
  
    describe "JSON" do
      let(:update) { put :update, id: 1, widget: { username: "Bookis" }, format: :json }
      it "attempts to update configurations" do
        widget.should_receive(:update_configuration).once.with({"username" => "Bookis"})
        update
      end
      it "returns a 204 on success" do
        widget.stub(:update_configuration) { true }
        update
        response.status.should eq 204
      end
      it "returns 422 on fail" do
        widget.stub(:update_configuration) { false }
        update
        response.status.should eq 422
      end
      it "returns the error messages on fail" do
        widget.stub(:update_configuration) { widget.errors[:base] << "There was an error" }
        update
        JSON.parse(response.body).should eq({"errors" => {"base" => ["There was an error"]}})
      end
    end
  end  

end