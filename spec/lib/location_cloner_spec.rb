require "spec_helper"

describe LocationCloner do
  let(:location_cloner) { LocationCloner.new(source_location.id, target_location.id) }
  let!(:source_location) { Fabricate(:location) }
  let!(:source_website) { Fabricate(:website, owner: source_location) }
  let!(:source_web_template) { Fabricate(:web_template, website: source_website) }
  let!(:target_location) { Fabricate(:location) }
  let!(:target_website) { Fabricate(:website, owner: target_location) }
  let!(:target_web_template) { Fabricate(:web_template, website: target_website) }

  describe "#clone" do
    let(:destroyer) { double(destroy: nil) }
    let(:cloner) { double(clone: nil) }

    before do
      WebTemplateDestroyer.stub(new: destroyer)
      WebTemplateCloner.stub(new: cloner)
    end

    before { location_cloner.clone }

    it "instantiates the web template destroyer" do
      expect(WebTemplateDestroyer).to have_received(:new).with(target_web_template.id)
    end

    it "calls destroy on the destroyer class" do
      expect(destroyer).to have_received(:destroy)
    end

    it "instantiates the web template cloner" do
      expect(WebTemplateCloner).to have_received(:new).
        with(source_web_template, target_location)
    end

    it "calls clone on the cloner class" do
      expect(cloner).to have_received(:clone)
    end
  end
end
