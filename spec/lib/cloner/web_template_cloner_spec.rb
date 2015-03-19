require "spec_helper"

describe Cloner::WebTemplateCloner do
  let(:web_template_cloner) { described_class.new(source_template, target_website) }
  let!(:target_website) { Fabricate(:website) }
  let!(:source_template) { Fabricate(:web_template, name: "Foo", type: "WebsiteTemplate") }
  let!(:source_layout) { Fabricate(:web_layout, web_template: source_template) }
  let!(:source_theme) { Fabricate(:web_theme, web_template: source_template) }
  let!(:source_drop_target) { Fabricate(:drop_target, web_template: source_template) }
  let!(:content_stripe_garden_widget) { Fabricate(:content_stripe_garden_widget) }
  let!(:source_widget) do
    Fabricate(:widget, drop_target: source_drop_target, garden_widget: content_stripe_garden_widget)
  end

  let!(:source_widget_2) do
    Fabricate(:widget, drop_target: source_drop_target, garden_widget: content_stripe_garden_widget)
  end

  describe "#clone" do
    let(:widget_cloner) { double(clone: nil) }

    before { Cloner::WidgetCloner.stub(new: widget_cloner) }

    context "before anything happens" do
      specify { expect(target_website.web_templates.size).to eq(0) }
      specify { expect(WebLayout.all.size).to eq(1) }
      specify { expect(WebTheme.all.size).to eq(1) }
      specify { expect(DropTarget.all.size).to eq(1) }
      specify { expect(Widget.all.size).to eq(2) }
    end

    context "after running clone" do
      let(:target_web_template) { target_website.web_templates.first }
      let(:target_widget) { target_web_template.drop_targets.first.widgets.first }

      before { web_template_cloner.clone }

      describe "web template cloning" do
        it "clones a WebTemplate to for the target website" do
          expect(target_website.web_templates.size).to eq(1)
        end

        it "creates the web template with the correct name" do
          expect(target_web_template.name).to eq("Foo")
        end
      end

      describe "web layout cloning" do
        it "clones a new WebLayout" do
          expect(WebLayout.all.size).to eq(2)
        end

        it "assigns the new web layout to the new template" do
          expect(target_web_template.web_layout).to be_present
        end
      end

      describe "web theme cloning" do
        it "clones a new WebTheme" do
          expect(WebTheme.all.size).to eq(2)
        end

        it "assigns the new web theme to the new template" do
          expect(target_web_template.web_theme).to be_present
        end
      end

      describe "drop target cloning" do
        it "clones a new DropTarget" do
          expect(DropTarget.all.size).to eq(2)
        end

        it "assigns the new drop target to the new template" do
          expect(target_web_template.drop_targets.size).to eq(1)
        end
      end

      it "calls WidgetCloner for each widget" do
        expect(widget_cloner).to have_received(:clone).exactly(2).times
      end
    end
  end
end
