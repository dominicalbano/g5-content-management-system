require "spec_helper"

describe WebTemplateWidgetCollector do
  let(:collector) { described_class.new(template) }
  let!(:template) { Fabricate(:web_page_template) }
  let!(:drop_target) { Fabricate(:drop_target, web_template: template) }
  let!(:widget) { Fabricate(:widget, drop_target: drop_target) }
  let!(:other_template) { Fabricate(:web_page_template) }
  let!(:other_drop_target) { Fabricate(:drop_target, web_template: other_template) }
  let!(:other_widget) { Fabricate(:widget, drop_target: other_drop_target) }

  describe "#collect" do
    it "collects all the widgets" do
      expect(collector.collect).to eq([widget])
    end
  end
end
