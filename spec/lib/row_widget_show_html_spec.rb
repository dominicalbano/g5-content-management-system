require "spec_helper"

describe RowWidgetShowHtml do
  let!(:setting) { Fabricate(:setting, name: name, owner: row_widget, value: widget.id) }
  let!(:row_layout) { Fabricate(:setting, name: "row_layout", owner: row_widget, value: value) }
  let!(:garden_widget) { Fabricate(:garden_widget, name: "row") }
  let!(:row_widget) { Fabricate(:widget, garden_widget: garden_widget) }
  let(:row_widget_show_html) { described_class.new(row_widget) }
  let(:widget) { Fabricate(:widget) }
  let(:name) { "foo" }
  let(:value) { "bar" }

  describe "#render" do
    describe "parsing" do
      let(:liquid_parse) { double(render: nil) }

      before do
        Liquid::Template.stub(parse: liquid_parse)
        Nokogiri.stub(parse: double(to_html: nil))
        row_widget_show_html.render
      end

      it "parses widget as a liquid template" do
        expect(liquid_parse).to have_received(:render).with("widget" => row_widget)
      end

      it "parses the liquid template with Nokogiri" do
        expect(Nokogiri).to have_received(:parse)
      end
    end

    describe "rendering" do
      let(:show) { Liquid::Template.parse(row_widget.show_html).render("widget" => row_widget) }
      let(:parsed) { Nokogiri.parse(show) }

      before { Nokogiri.stub(parse: parsed) }
      subject { row_widget_show_html.render }

      it { should eq(parsed.to_html) }

      context "column rendering" do
        after { subject }

        context "single column" do
          let(:name) { "column_one_widget_id" }

          it "calls render_column_one_widget" do
            expect(row_widget_show_html).to receive(:render_column_one_widget)
          end
        end

        context "two columns" do
          let(:name) { "column_two_widget_id" }
          let(:value) { "halves" }

          it "calls render_column_one_widget" do
            expect(row_widget_show_html).to receive(:render_column_two_widget)
          end
        end

        context "three columns" do
          let(:name) { "column_three_widget_id" }
          let(:value) { "thirds-1" }

          it "calls render_column_three_widget" do
            expect(row_widget_show_html).to receive(:render_column_three_widget)
          end
        end

        context "four columns" do
          let(:name) { "column_four_widget_id" }
          let(:value) { "quarters" }

          it "calls render_column_three_widget" do
            expect(row_widget_show_html).to receive(:render_column_four_widget)
          end
        end
      end
    end
  end

  describe "#render_column_one_widget" do
    subject { row_widget_show_html.render_column_one_widget }
  end

  describe "#render_column_two_widget" do
    subject { row_widget_show_html.render_column_two_widget }
  end

  describe "#render_column_three_widget" do
    subject { row_widget_show_html.render_column_three_widget }
  end

  describe "#render_column_four_widget" do
    subject { row_widget_show_html.render_column_four_widget }
  end
end
