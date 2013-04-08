require 'spec_helper'

describe WidgetEntriesController do
  let(:widget_entry) { Fabricate.build(:widget_entry) }

  describe "#index" do
    before do
    end
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
    it "assigs decorated collection to @widget_entries" do
      get :index
      assigns(:widget_entries).should be_kind_of Draper::CollectionDecorator
    end
  end

  describe "#show" do
    before do
      WidgetEntry.stub(:find).and_return(widget_entry)
    end
    it "show action should render show template" do
      get :show, id: 1
      response.should render_template(:show)
    end
    it "assigs decorated widget entry to @widget_entry" do
      get :show, id: 1
      assigns(:widget_entry).should be_kind_of WidgetEntryDecorator
    end
  end
end
