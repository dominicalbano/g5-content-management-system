require "spec_helper"

describe WebTemplateCloner do
  let(:web_template_cloner) { WebTemplateCloner.new(source_template, target_website) }
  let!(:target_website) { Fabricate(:website) }

  let!(:source_template) { Fabricate(:web_template, name: "Foo", slug: "web-template") }
  let!(:source_layout) { Fabricate(:web_layout, web_template: source_template) }
  let!(:source_theme) { Fabricate(:web_theme, web_template: source_template) }
  let!(:source_drop_target) { Fabricate(:drop_target, web_template: source_template) }
  let!(:row_garden_widget) { Fabricate(:row_garden_widget) }
  let!(:source_widget) do
    Fabricate(:widget, drop_target: source_drop_target,
                       garden_widget: row_garden_widget)
  end
  let!(:source_widget_widget) { Fabricate(:widget, drop_target: nil) }
  let!(:source_widget_id_setting) do
    Fabricate(:setting, owner: source_widget,
                        name: "column_one_widget_id",
                        value: source_widget_widget.id )
  end
  let!(:source_widget_name_setting) do
    Fabricate(:setting, owner: source_widget,
                        name: "column_one_widget_name",
                        value: source_widget_widget.name )
  end

  describe "#clone" do
    context "before anything happens" do
      specify { expect(target_website.web_templates.size).to eq(0) }
      specify { expect(WebLayout.all.size).to eq(1) }
      specify { expect(WebTheme.all.size).to eq(1) }
      specify { expect(DropTarget.all.size).to eq(1) }
      specify { expect(Widget.all.size).to eq(2) }
      specify { expect(Setting.all.size).to eq(1) }
    end

    context "after running clone" do
      let(:target_web_template) { target_website.web_templates.first }
      let(:target_widget) { target_web_template.drop_targets.first.widgets.first }

      subject { web_template_cloner.clone }
      before { subject }

      describe "web template cloning" do
        it "clones a WebTemplate to for the target website" do
          expect(target_website.web_templates.size).to eq(1)
        end

        it "creates the web template with the correct name" do
          expect(target_web_template.name).to eq("Foo")
        end
      end

      it "clones a WebLayout to for the target website template" do
        expect(target_web_template.web_layout).to be_present
      end

      it "clones a WebTheme to for the target website template" do
        expect(target_web_template.web_theme).to be_present
      end

      it "clones a DropTarget to for the target website template" do
        expect(target_web_template.drop_targets.size).to eq(1)
      end

      it "clones a Widget to for the target drop target" do
        expect(target_web_template.drop_targets.first.widgets.size).to eq(1)
      end

      it "clones a Setting for the widget" do
        expect(target_widget.settings.size).to eq(1)
      end

      it "clones a Widget to for the target drop target" do
        expect(Widget.all.size).to eq(4)
      end
    end
  end
end
