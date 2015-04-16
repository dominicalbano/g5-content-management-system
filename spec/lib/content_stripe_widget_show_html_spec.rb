require "spec_helper"

describe ContentStripeWidgetShowHtml do
  let!(:setting) { Fabricate(:setting, name: name, owner: cs_widget, value: widget.id) }
  let!(:row_layout) { Fabricate(:setting, name: "row_layout", owner: cs_widget, value: value) }
  let!(:garden_widget) { Fabricate(:garden_widget, name: "Content Stripe", widget_id: 11) }
  let!(:cs_widget) { Fabricate(:widget, garden_widget: garden_widget) }
  let(:cs_widget_show_html) { described_class.new(cs_widget) }
  let(:widget) { Fabricate(:widget) }
  let(:name) { "foo" }
  let(:value) { "bar" }

  describe "#render" do
    describe "parsing" do
      let(:liquid_parse) { double(render: nil) }

      before do
        Liquid::Template.stub(parse: liquid_parse)
        Nokogiri.stub(parse: double(to_html: nil))
        cs_widget_show_html.render
      end

      it "parses widget as a liquid template" do
        expect(liquid_parse).to have_received(:render)
      end

      it "parses the liquid template with Nokogiri" do
        expect(Nokogiri).to have_received(:parse)
      end
    end

    describe "rendering" do
      let(:show) { Liquid::Template.parse(cs_widget.show_html).render("widget" => cs_widget.liquid_widget_drop) }
      let(:parsed) { Nokogiri.parse(show) }

      before { Nokogiri.stub(parse: parsed) }
      subject { cs_widget_show_html.render }

      it { should eq(parsed.to_html) }

      context "column rendering" do
        after { subject }

        context "single column" do
          let(:name) { "column_1_widget_id" }
          before { cs_widget.reload }

          it "calls render_widget once" do
            expect(cs_widget_show_html).to receive(:render_widget).once
          end
        end

        context "two columns" do
          let(:name) { "column_2_widget_id" }
          let(:value) { "halves" }
          before { cs_widget.reload }

          it "calls render_widget twice" do
            expect(cs_widget_show_html).to receive(:render_widget).exactly(2).times
          end
        end

        context "two columns" do
          let(:name) { "column_2_widget_id" }
          let(:value) { "uneven-thirds-1" }
          before { cs_widget.reload }

          it "calls render_widget twice" do
            expect(cs_widget_show_html).to receive(:render_widget).exactly(2).times
          end
        end

        context "two columns" do
          let(:name) { "column_2_widget_id" }
          let(:value) { "uneven-thirds-2" }
          before { cs_widget.reload }

          it "calls render_widget twice" do
            expect(cs_widget_show_html).to receive(:render_widget).exactly(2).times
          end
        end

        context "three columns" do
          let(:name) { "column_3_widget_id" }
          let(:value) { "thirds" }
          before { cs_widget.reload }

          it "calls render_widget three times" do
            expect(cs_widget_show_html).to receive(:render_widget).exactly(3).times
          end
        end

        context "four columns" do
          let(:name) { "column_4_widget_id" }
          let(:value) { "quarters" }
          before { cs_widget.reload }

          it "calls render_widget four times" do
            expect(cs_widget_show_html).to receive(:render_widget).exactly(4).times
          end
        end
      end
    end
  end
end
