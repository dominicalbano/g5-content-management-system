require "spec_helper"

describe Category do
  describe "validations" do
    it "should require name" do
      Fabricate.build(:client, name: "").should_not be_valid
    end
  end
end
