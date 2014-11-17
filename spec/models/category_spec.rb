require "spec_helper"

describe Category do
  let!(:category) { Fabricate(:category, name: "Foo Bar") }

  describe "validations" do
    it "requires name" do
      expect(Fabricate.build(:client, name: "")).to_not be_valid
    end

    it "requires slug on existing records" do
      category.slug = ""
      expect(category).to_not be_valid
    end
  end

  describe "slug generation" do
    it "sets the slug based on the name" do
      expect(category.slug).to eq("foo-bar")
    end
  end
end
