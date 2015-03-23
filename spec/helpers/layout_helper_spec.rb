require 'spec_helper'

describe LayoutHelper do
  describe "#title" do
    it "sets the title" do
      helper.title "Title"
      view.content_for(:title).should eq "Title"
    end
    
    it "says the title should show" do
      helper.title "Title"
      helper.show_title?.should be_truthy
    end
  end
  
  describe "#show_title?" do
    it "defaults to nil" do
      helper.show_title?.should be_falsey
    end
    
    it "is true" do
      assign(:show_title, true)
      helper.show_title?.should be_truthy
    end
  end

  describe "#header_right" do
    it "sets the header_right" do
      helper.header_right "Header Right"
      view.content_for(:header_right).should eq "Header Right"
    end
    
    it "says the header_right should show" do
      helper.header_right "Header Right"
      helper.show_header_right?.should be_truthy
    end

    it "says the header_right should not show" do
      helper.header_right "Header Right", false
      helper.show_header_right?.should be_falsey
    end
  end
  
  describe "#show_header_right?" do
    it "defaults to nil" do
      helper.show_header_right?.should be_falsey
    end
    
    it "is true" do
      assign(:show_header_right, true)
      helper.show_header_right?.should be_truthy
    end
  end
  
  describe "#flash_div" do
    it "is nil if there is no flash" do
      helper.flash_div(:notice).should be_nil
    end
    
    it "creates a div with class error" do
      flash[:error] = "This is a error"
      helper.flash_div(:error).should eq "<div class=\"alert alert-error\"><p>This is a error</p></div>"
    end
    
    it "creates a div with class info" do
      flash[:notice] = "This is a notice"
      helper.flash_div(:notice).should eq "<div class=\"alert alert-info\"><p>This is a notice</p></div>"
    end
  end
end
