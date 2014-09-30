37

class Component
  include ComponentGardenable
  set_garden_url ENV["WIDGET_GARDEN_URL"]

  def url
    "http://google.com/"
  end
end

describe ComponentGardenable, vcr: { record: :new_episodes } do
  before do
    stub_const "MAIN_APP_UID",
               'http://g5-configurator.herokuapp.com/apps/g5-cms-1s7nay2b-mj-storage-client'
  end
  describe ".components_microformats" do
    it "returns microformats when no error" do
      Component.components_microformats.should be_present
    end

    describe "when not modified" do
      it "returns @microformats if there is an OpenURI::HTTPError 304" do
        Component.components_microformats
        Microformats2::Parser.any_instance.stub(:parse).
          and_raise(OpenURI::HTTPError.new("304 Not Modified", nil))
        Component.components_microformats.should be_present
      end
    end

    context "garden_microformats responds to g5_components" do
      describe "private widget not ours" do
        before do
          stub_const "MAIN_APP_UID", 'foo'
        end
        it "should reject components when they have targets not including our UID" do
          Component.components_microformats.length.should == 44
        end
      end

      describe "private widget targets us" do
        it "should accept components when they have targets including our UID" do
          pending "implement this spec when there is a private widget"
          fail
        end
      end
    end

    it "raises error if there is an OpenURI::HTTPError other than 304" do
      Microformats2::Parser.any_instance.stub(:parse).
        and_raise(OpenURI::HTTPError.new("400 Not Found", nil))
      expect{ Component.components_microformats }.to raise_error(OpenURI::HTTPError)
    end
  end

  describe "#component_microformat" do
    let(:component) { Component.new }

    describe "when no component is found at url" do
      it "raises an error" do
        expect { component.send(:component_microformat) }.to raise_error(
          StandardError, "No h-g5-component found at url: #{component.url}")
      end
    end

    describe "when OpenURI::HTTPError" do
      it "logs a failed request" do
        Microformats2.stub(:parse).
          and_raise(OpenURI::HTTPError.new("404 Object Not Found", nil))
        Rails.logger.should_receive(:warn).with("404 Object Not Found")
        component.send(:component_microformat)
      end
    end
  end
end
