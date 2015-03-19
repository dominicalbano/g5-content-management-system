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
    before { Fabricate(:client, uid: "http://g5-hub.herokuapp.com/g5-c-12345-test") }
    subject { helper.leads_service_js }

    it { should eq("//g5-cls-12345-test.herokuapp.com/assets/form_enhancer.js") }
  end

  describe "user class methods" do
    let(:email) { "foo@bar.com" }

    before { view.stub(current_user: double(email: email) ) }

    describe "#g5_user?" do
      subject { helper.g5_user? }

      context "non g5 user" do
        it { is_expected.to be_falsey }
      end

      context "a getg5 g5 user" do
        let(:email) { "foo@getg5.com" }
        it { is_expected.to be_truthy }
      end

      context "a g5platform g5 user" do
        let(:email) { "foo@g5platform.com" }
        it { is_expected.to be_truthy }
      end

      context "a g5searchmarketing g5 user" do
        let(:email) { "foo@g5searchmarketing.com" }
        it { is_expected.to be_truthy }
      end
    end

    describe "#user_class" do
      subject { helper.user_class }

      context "non g5 user" do
        it { is_expected.to eq("client-user") }
      end

      context "a getg5 g5 user" do
        let(:email) { "foo@getg5.com" }
        it { is_expected.to eq("g5-user") }
      end

      context "a g5platform g5 user" do
        let(:email) { "foo@g5platform.com" }
        it { is_expected.to eq("g5-user") }
      end

      context "a g5searchmarketing g5 user" do
        let(:email) { "foo@g5searchmarketing.com" }
        it { is_expected.to eq("g5-user") }
      end
    end
  end
end
