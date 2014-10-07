require 'spec_helper'

describe Api::V1::AssetsController, :auth_controller do
  describe "#sign_upload" do
    it "should render json template with header data for aws" do
      get :sign_upload, {name: 'foo', :'locationName'=> 'hollywood'}
      parsed_body = JSON.parse(response.body)
      parsed_body["acl"].should == "public-read"
    end
  end
  describe "#sign_delete" do
    it "should render json template with header data for aws" do
      get :sign_delete, {name: 'foo', :'locationName'=> 'hollywood'}
      parsed_body = JSON.parse(response.body)
      parsed_body["success_action_status"].should == "201"
    end
  end
end

