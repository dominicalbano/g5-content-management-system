require 'spec_helper'

describe SessionsController do
  fixtures :all
  render_views

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when authentication is invalid" do
    Client.stub!(:authenticate).and_return(nil)
    post :create
    response.should render_template(:new)
    session['client_id'].should be_nil
  end

  it "create action should redirect when authentication is valid" do
    Client.stub!(:authenticate).and_return(Client.first)
    post :create
    response.should redirect_to(root_url)
    session['client_id'].should == Client.first.id
  end
end
