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

  describe "#leads_service_js" do
    before { helper.stub_chain(:client, urn: urn) }
    subject { helper.leads_service_js }

    context "with a shorter URN" do
      let(:urn) { "g5-c-12345-testing" }
      it { should eq("https://g5-cls-12345-testing.herokuapp.com/assets/form_enhancer.js") }
    end

    context "with a URN over heroku's app length limit" do
      let(:urn) { "g5-cls-1skckws2-case-and-associates-properties-inc" }
      it { should eq("https://g5-cls-1skckws2-case-and-assoc.herokuapp.com/assets/form_enhancer.js") }
    end
  end
end
