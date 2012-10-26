require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  fixtures :all
  render_views

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when authentication is invalid" do
    User.stub(:authenticate).and_return(nil)
    post :create
    response.should render_template(:new)
    session['user_id'].should be_nil
  end

  it "create action should redirect when authentication is valid" do
    User.stub(:authenticate).and_return(User.first)
    post :create
    response.should redirect_to(root_url)
    session['user_id'].should == User.first.id
  end
end
