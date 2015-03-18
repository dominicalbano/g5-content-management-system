require "spec_helper"

describe LayoutWidgetDestroyer do
  let!(:widget) { Fabricate(:widget) }
  let(:destroyer) { described_class.new(setting) }

  describe "#destroy" do
    context "a child widget id setting" do
      let!(:setting) do
        Fabricate(:setting, name: "row_1_widget_id", value: widget.id)
      end

      it "destroys the setting's widget" do
        expect { destroyer.destroy }.to change{ Widget.count }.from(2).to(1)
      end
    end

    context "a non child widget id setting" do
      let!(:setting) { Fabricate(:setting, name: "foo") }

      it "does not destroy any widgets" do
        expect { destroyer.destroy }.to_not change{ Widget.count }
      end
    end
  end
end
