require "spec_helper"

describe RowWidgetAssetCollector do
  let(:asset_collector) { described_class.new(template) }
  let!(:template) { Fabricate(:web_page_template) }
  let!(:drop_target) { Fabricate(:drop_target, web_template: template) }
  let!(:garden_widget) { Fabricate(:garden_widget, name: "Row") }
  let!(:row_widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
  let!(:setting) { Fabricate(:setting, name: "Row", owner: row_widget) }
  let!(:row_widget_widget) { Fabricate(:widget, garden_widget: row_widget_widget_garden_widget) }
  let!(:row_widget_widget_garden_widget) do
    Fabricate(
      :garden_widget,
      name: "Column",
      show_javascript: "/foo.js",
      show_stylesheets: ["/foo.css"]
    )
  end
  let!(:column_setting) do
    Fabricate(
      :setting,
      name: "column_one_widget_id",
      owner: row_widget,
      value: row_widget_widget.id
    )
  end

  before do
    row_widget.settings << setting
    row_widget.settings << column_setting
  end

  describe "#javascripts" do
    subject { asset_collector.javascripts }

    context "a template with no row widget" do
      let!(:row_widget) { Fabricate(:widget) }

      it { should be_empty }
    end

    context "a template with a row widget" do
      it "collects the javascripts from the row widget's widgets" do
        expect(subject).to eq(["/foo.js"])
      end

      context "a row widget using a column widget" do
        let!(:column_widget_widget) do
          Fabricate(:widget, garden_widget: column_widget_widget_garden_widget)
        end
        let!(:column_widget_widget_garden_widget) do
          Fabricate(
            :garden_widget,
            name: "Map",
            show_javascript: "/bar.js",
            show_stylesheets: ["/bar.css"]
          )
        end
        let!(:column_row_setting) do
          Fabricate(
            :setting,
            name: "row_one_widget_id",
            owner: row_widget_widget,
            value: column_widget_widget.id
          )
        end

        it "collects the javascripts from the row and column widget's widgets" do
          expect(subject).to eq(["/foo.js", "/bar.js"])
        end
      end
    end
  end

  describe "#stylesheets" do
    subject { asset_collector.stylesheets }

    context "a template with no row widget" do
      let!(:row_widget) { Fabricate(:widget) }

      it { should be_empty }
    end

    context "a template with a row widget" do
      it "collects the stylesheets from the row widget's widgets" do
        expect(subject).to eq(["/foo.css"])
      end

      context "a row widget using a column widget" do
        let!(:column_widget_widget) do
          Fabricate(:widget, garden_widget: column_widget_widget_garden_widget)
        end
        let!(:column_widget_widget_garden_widget) do
          Fabricate(
            :garden_widget,
            name: "Map",
            show_javascript: "/bar.js",
            show_stylesheets: ["/bar.css"]
          )
        end
        let!(:column_row_setting) do
          Fabricate(
            :setting,
            name: "row_one_widget_id",
            owner: row_widget_widget,
            value: column_widget_widget.id
          )
        end

        it "collects the javascripts from the row and column widget's widgets" do
          expect(subject).to eq(["/foo.css", "/bar.css"])
        end
      end
    end
  end
end
