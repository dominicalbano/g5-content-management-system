require 'spec_helper'

describe UpdateNavigationSettingsJob do 
  context "#perform" do
    let(:website_id){ 999 }
    let(:website){ double(:website) }

    it "updates navigation settings" do
      expect(Website).to receive(:find).and_return(website)
      expect(website).to receive(:update_navigation_settings)
      described_class.perform(website_id)
    end  
  end  
  
end