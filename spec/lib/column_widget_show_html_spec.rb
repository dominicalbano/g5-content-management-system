require "spec_helper"

describe ColumnWidgetShowHtml do
  let!(:setting) { Fabricate(:setting, name: name, owner: column_widget, value: widget.id) }
  let!(:row_count) { Fabricate(:setting, name: "row_count", owner: column_widget, value: value) }
  let!(:garden_widget) { Fabricate(:garden_widget, name: "Column") }
  let!(:column_widget) { Fabricate(:widget, garden_widget: garden_widget) }
  let(:column_widget_show_html) { described_class.new(column_widget) }
  let(:widget) { Fabricate(:widget) }
  let(:name) { "foo" }
  let(:value) { "one" }

  describe "#render" do
    describe "parsing" do
      let(:liquid_parse) { double(render: nil) }

      before do
        Liquid::Template.stub(parse: liquid_parse)
        Nokogiri.stub(parse: double(to_html: nil))
        column_widget_show_html.render
      end

      it "parses widget as a liquid template" do
        expect(liquid_parse).to have_received(:render).with("widget" => column_widget)
      end

      it "parses the liquid template with Nokogiri" do
        expect(Nokogiri).to have_received(:parse)
      end
    end

    describe "rendering" do
      let(:show) { Liquid::Template.parse(column_widget.show_html).render("widget" => column_widget) }
      let(:parsed) { Nokogiri.parse(show) }

      before { Nokogiri.stub(parse: parsed) }
      subject { column_widget_show_html.render }

      it { should eq(parsed.to_html) }

      context "row rendering" do
        after { subject }

        context "single row" do
          let(:name) { "row_1_widget_id" }

          it "calls render_widget once" do
            expect(column_widget_show_html).to receive(:render_widget).once
          end
        end

        context "two rows" do
          let(:name) { "row_2_widget_id" }
          let(:value) { "two" }

          it "calls render_widget twice" do
            expect(column_widget_show_html).to receive(:render_widget).exactly(2).times
          end
        end

        context "three rows" do
          let(:name) { "row_3_widget_id" }
          let(:value) { "three" }

          it "calls render_widget three times" do
            expect(column_widget_show_html).to receive(:render_widget).exactly(3).times
          end
        end

        context "four rows" do
          let(:name) { "row_4_widget_id" }
          let(:value) { "four" }

          it "calls render_widget four times" do
            expect(column_widget_show_html).to receive(:render_widget).exactly(4).times
          end
        end

        context "five rows" do
          let(:name) { "row_5_widget_id" }
          let(:value) { "five" }

          it "calls render_widget five times" do
            expect(column_widget_show_html).to receive(:render_widget).exactly(5).times
          end
        end

        context "six rows" do
          let(:name) { "row_6_widget_id" }
          let(:value) { "six" }

          it "calls render_widget six times" do
            expect(column_widget_show_html).to receive(:render_widget).exactly(6).times
          end
        end
      end
    end
  end
end

