require "spec_helper"

describe ApplicationHelper do
  
  describe "#image_tag_or_placeholder" do
    it "returns a placehold.it url" do
      helper.image_tag_or_placeholder(nil).should match "http://placehold.it/100x100"
    end
    
    it "adds a placehold.it" do
      helper.image_tag_or_placeholder(nil, width: 200).should match "http://placehold.it/200x100"
    end
    
    it "acts as a normal image_tag" do
      helper.image_tag('image.jpg').should match "/image.jpg"
    end
  end
end