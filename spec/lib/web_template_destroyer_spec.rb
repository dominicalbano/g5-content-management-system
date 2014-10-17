require "spec_helper"

describe WebTemplateDestroyer do
  let(:destroyer) { described_class.new(template_id) }
  let(:widget_collector) { double(collect: widgets) }
  let(:widgets) { [widget_one, widget_two] }
  let!(:widget_one) { Fabricate(:widget) }
  let!(:widget_two) { Fabricate(:widget) }
  let!(:template_id) { Fabricate(:web_page_template).id }

  before { WebTemplateWidgetCollector.stub(new: widget_collector) }

  subject { destroyer.destroy }

  describe "#destroy" do
    it "destroys widgets returned from the widget collector" do
      expect { subject }.to change { Widget.all.size }.from(2).to(0)
    end

    it "destroys the web template" do
      expect { subject }.to change { WebTemplate.all.size }.from(1).to(0)
    end
  end
end
