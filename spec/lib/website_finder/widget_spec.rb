require "spec_helper"

describe WebsiteFinder::Widget do
  let(:finder) { described_class.new(widget) }
  let!(:website) { Fabricate(:website) }
  let!(:web_template) { Fabricate(:web_template, website: website) }
  let!(:drop_target) { Fabricate(:drop_target, web_template: web_template) }

  describe "#find" do
    subject { finder.find }

    context "a widget belonging to a drop target" do
      let(:widget) { Fabricate(:widget, drop_target: drop_target) }

      specify { expect(subject).to eq(website)  }
    end

    context "a widget with no drop target" do
      let(:widget) { Fabricate(:widget, drop_target: nil) }
      let!(:parent_widget) { Fabricate(:widget, drop_target: drop_target) }
      context "an existing setting" do
        let!(:setting) do
          Fabricate(:setting,
                    owner: parent_widget,
                    name: "column_one_widget_id",
                    value: widget.id
                   )
        end

        specify { expect(subject).to eq(website)  }
      end

      context "no existing setting" do
        specify { expect(subject).to be_nil  }
      end
    end
  end
end
