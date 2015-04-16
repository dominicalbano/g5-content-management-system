require "spec_helper"

describe Cloner::WidgetCloner do
  describe "#clone" do
    let(:website) { Fabricate(:website) }
    let(:template) { Fabricate(:web_template, website: website) }
    let(:target_drop_target) { Fabricate(:drop_target, web_template: template) }
    
    context "with row widget" do
      let(:content_stripe_garden_widget) { Fabricate(:content_stripe_garden_widget) }
      let(:html_garden_widget) { Fabricate(:html_garden_widget) }
      let(:content_stripe_widget) { Fabricate(:widget, garden_widget: content_stripe_garden_widget) }
      let(:widget_count) { 2 }
      let(:settings_count) { content_stripe_garden_widget.settings.size + html_garden_widget.settings.size }

      subject { Cloner::WidgetCloner.new(content_stripe_widget, target_drop_target).clone }

      before do
        content_stripe_widget.set_child_widget(1, html_garden_widget)
        content_stripe_widget.reload
        subject
      end

      context "after running clone" do
        describe "widget cloning" do
          it "clones a new widget" do
            expect(Widget.count).to eq(2*widget_count)
          end

          it "assigns the new widget to the new drop target" do
            expect(target_drop_target.widgets.size).to eq(1)
          end
        end

        describe "setting cloning" do
          it "clones widget settings" do
            expect(Setting.all.size).to eq(2*settings_count)
          end

          it "assigns the new widget to the new drop target" do
            expect(target_drop_target.widgets.size).to eq(1)
          end
        end

        describe "child widget cloning" do
          it "assigns the child widget to the new widget" do
            expect(target_drop_target.widgets.first.widgets.size).to eq(1)
          end
        end
      end
    end

    context "widget cloning" do
      let(:analytics_garden_widget) { Fabricate(:analytics_garden_widget) }
      let(:analytics_widget) { Widget.create(garden_widget: analytics_garden_widget) }
      subject { @cloned_widget = Cloner::WidgetCloner.new(analytics_widget, target_drop_target).clone }

      before do
        analytics_widget.settings.each{|s| s.value = 'dont clone'}
        analytics_widget.save
        subject
      end
      it "doesnt clone analytics widget settings" do
        @cloned_widget.reload.settings.each do |setting|
          expect(setting.value).to be(nil)
        end
      end
    end

  end
end

