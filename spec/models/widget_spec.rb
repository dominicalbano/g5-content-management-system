require "spec_helper"

describe Widget, vcr: VCR_OPTIONS do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }

  let!(:website) { Fabricate(:website, owner: location, website_template: web_template) }
  let!(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let!(:garden_web_theme) { Fabricate(:garden_web_theme, primary_color: "#000000") }
  let!(:web_template) { Fabricate(:website_template, web_theme: web_theme) }

  let!(:page_template) { Fabricate(:web_page_template, website: website)}
  let(:drop_target) { Fabricate(:drop_target, web_template: page_template) }
  
  describe "validations" do
    let(:widget){Fabricate(:widget)}
    let(:no_garden_widget){Fabricate.build(:widget, {garden_widget: nil})}

    it "builds a valid widget" do
      expect(widget).to be_valid
    end

    it "requires a garden_widget_id" do
      expect(no_garden_widget).to_not be_valid
    end
  end

  describe "#update_attributes" do
    let(:garden_widget) { Fabricate(:garden_widget) }
    let(:widget) { Fabricate(:widget, garden_widget: garden_widget) }
    let(:setting) { Fabricate(:setting, owner: widget) }

    before { widget.reload }

    it "accepts nested attributes for settings" do
      widget.update_attributes(settings_attributes: {
        id: setting.id,
        name: "TEST"
      })
      expect(setting.reload.name).to eq "TEST"
    end
  end

  describe "#render_show_html" do
    context "content stripe widget" do
      let(:garden_widget) { Fabricate(:content_stripe_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:row_widget_show_html) { double(render: nil) }

      before { ContentStripeWidgetShowHtml.stub(new: row_widget_show_html) }

      it "calls render on ContentStripeWidgetShowHtml" do
        widget.render_show_html
        expect(row_widget_show_html).to have_received(:render)
      end
    end

    context "column widget" do
      let(:garden_widget) { Fabricate(:column_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:column_widget_show_html) { double(render: nil) }

      before { ColumnWidgetShowHtml.stub(new: column_widget_show_html) }

      it "calls render on ColumnWidgetShowHtml" do
        widget.render_show_html
        expect(column_widget_show_html).to have_received(:render)
      end
    end

    context "liquid widgets" do
      let(:garden_widget) { Fabricate(:html_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:liquid_text) { "{{client_name}}" }

      before do
        widget.set_setting('text', liquid_text)
      end

      it "does not escape funky characters" do
        widget.stub(:show_html) { "^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" }
        expect(widget.render_show_html).to eq widget.show_html
      end

      it "supports liquid - processes liquid variables" do  
        expect(widget.render_show_html).to include client.name
      end

      it "no liquid - does not process liquid variables" do
        widget.stub(:liquid) { false }
        expect(widget.render_show_html).to include liquid_text
      end
    end

    context "all other widgets" do
      let(:garden_widget) { Fabricate(:garden_widget) }
      let(:widget) { Fabricate(:widget) }
      
      it "does not escape funky characters" do
        widget.stub(:show_html) { "^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" }
        expect(widget.render_show_html).to eq widget.show_html
      end
    end
  end

  describe "#render_edit_html" do
    let(:widget) { Fabricate.build(:widget) }

    it "does not escape funky characters" do
      widget.stub(:edit_html) { "^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" }
      expect(widget.render_edit_html).to eq widget.edit_html
    end
  end

  describe "#create_widget_entry_if_updated" do
    let(:widget) { Fabricate(:widget) }

    context "when no widget entries exist" do
      before do
        widget.widget_entries = []
      end

      it "returns a new widget entry" do
        expect(widget.create_widget_entry_if_updated).to be_kind_of WidgetEntry
      end
    end

    context "when widget entries exist" do
      before do
        widget.widget_entries.create
      end

      it "returns a new widget entry if the widget has been updated" do
        widget.updated_at = Time.now + 1.day
        expect(widget.create_widget_entry_if_updated).to be_kind_of WidgetEntry
      end

      it "returns nil if the widget has not been updated" do
        widget.updated_at = Time.now - 1.day
        expect(widget.create_widget_entry_if_updated).to be_nil
      end
    end
  end
  describe "instance methods" do
    let!(:garden_widget) {Fabricate.create(:garden_widget,
                                 {  show_stylesheets: ["foo.css", "bar.css"],
                                    show_javascript: "show.js",
                                    lib_javascripts: ["a.js", "b.js"],
                                    settings: [{:name=>"test", :editable=>"true", :default_value=>"foo", :categories=>["Instance"]}]  })}
    let(:cs_garden_widget) { Fabricate(:content_stripe_garden_widget) }
    let(:col_garden_widget) { Fabricate(:column_garden_widget) }

    let!(:widget) {Fabricate.create(:widget, garden_widget: garden_widget)}
    
    before { widget.set_setting('test', 'foo') }

    describe "#show_stylesheets" do
      it "returns stylesheets associated through garden_widget" do
        expect(widget.show_stylesheets).to eq(["foo.css","bar.css"])
      end
    end

    describe "#show_javascripts" do
      it "returns associated javascripts" do
        expect(widget.show_javascripts).to eq(["show.js"])
      end
    end

    describe "#lib_javascripts" do
      it "returns associated lib javascripts" do
        expect(widget.lib_javascripts).to eq(["a.js","b.js"])
      end
    end

    describe "#widget_type" do
      it "returns the Garden Widget type" do
        expect(widget.widget_type).to eq(garden_widget.widget_type)
      end
    end

    describe "#get_setting" do
      it "returns setting if exists" do
        expect(widget.get_setting('test')).to_not be_nil
        expect(widget.get_setting('test').name).to eq('test')
        expect(widget.get_setting('test').value).to eq('foo')
      end

      it "returns nil if setting does not exist" do
        expect(widget.get_setting('fail')).to be_nil
      end
    end

    describe "#get_setting_value" do
      it "returns setting value if exists" do
        expect(widget.get_setting_value('test')).to eq('foo')
      end

      it "returns nil if setting does not exist" do
        expect(widget.get_setting_value('fail')).to be_nil
      end
    end

    describe "#set_setting" do
      before { widget.set_setting('test', 'bar') }

      it "updates the setting" do
        expect(widget.get_setting_value('test')).to eq('bar')
      end
    end

    describe "#widgets" do
      it "returns empty array by default" do
        expect(widget.widgets).to be_empty
      end

      context "content stripe" do
        let(:cs) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        let(:col) { Fabricate(:widget, garden_widget: col_garden_widget, drop_target: drop_target) }
        
        context "nested one deep" do
          before { cs.set_child_widget(1, widget) }
          it "returns nested widgets" do
            expect(cs.widgets).to eq([widget])
          end
        end

        context "nested two deep" do
          before do
            col.set_child_widget(1, widget)
            cs.set_child_widget(1, col) 
          end
          it "returns nested widgets" do
            expect(cs.widgets).to eq([col, widget])
          end
        end

        context "has no nested widgets" do
          it "returns empty array" do
            expect(cs.widgets).to be_empty
          end
        end
      end

      context "column widget" do
        let(:col) { Fabricate(:widget, garden_widget: col_garden_widget, drop_target: drop_target) }
        context "has nested widgets" do
          before { col.set_child_widget(1, widget) }
          it "returns nested widgets" do
            expect(col.widgets).to eq([widget])
          end
        end

        context "has no nested widgets" do
          it "returns empty array" do
            expect(col.widgets).to be_empty
          end
        end
      end
    end

    describe "#liquid_parameters" do
      context "non-liquid widget" do
        it "returns empty if not liquid" do
          expect(widget.liquid_parameters).to be_empty
        end
      end

      context "liquid widget" do
        let(:html_widget) { Fabricate(:html_garden_widget) }
        let(:widget) { Fabricate(:widget, garden_widget: html_widget, drop_target: drop_target) }
        it "returns array of liquid parameters if liquid" do
          expect(widget.liquid_parameters).to_not be_empty
        end

        it "gets correct client info" do
          expect(widget.liquid_parameters['client_name']).to eq(client.name)
          expect(widget.liquid_parameters['client_vertical']).to eq(client.vertical)
        end

        it "gets correct web template info" do
          expect(widget.liquid_parameters['page_name']).to eq(page_template.name)
        end

        it "gets correct location info" do
          expect(widget.liquid_parameters['location_name']).to eq(location.name)
          expect(widget.liquid_parameters['location_city']).to eq(location.city)
          expect(widget.liquid_parameters['location_state']).to eq(location.state)
          expect(widget.liquid_parameters['location_neighborhood']).to eq(location.neighborhood)
          expect(widget.liquid_parameters['location_floor_plans']).to eq(location.floor_plans)
          expect(widget.liquid_parameters['location_primary_amenity']).to eq(location.primary_amenity)
          expect(widget.liquid_parameters['location_qualifier']).to eq(location.qualifier)
          expect(widget.liquid_parameters['location_primary_landmark']).to eq(location.primary_landmark)
        end
      end
    end 

    describe "#parent_widget" do
      let(:garden_widget) { Fabricate(:garden_widget) }
      let(:cs_garden_widget) { Fabricate(:content_stripe_garden_widget) }
      let(:col_garden_widget) { Fabricate(:column_garden_widget) }


      context "has no parent" do
        let(:widget) { Fabricate.build(:widget, garden_widget: garden_widget, drop_target: drop_target) }

        it "returns nil as parent" do
          expect(widget.parent_widget).to be_nil
        end
      end

      context "has parent" do
        let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: nil) }
        let(:parent) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        before do
          parent.set_child_widget(1, widget)
        end

        it "returns correct parent widget" do
          expect(widget.parent_widget).to_not be_nil
          expect(widget.parent_widget.id).to eq parent.id
          expect(widget.parent_widget.parent_widget).to be_nil
        end
      end

      context "has parent and grandparent" do
        let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: nil) }
        let(:parent) { Fabricate(:widget, garden_widget: col_garden_widget, drop_target: nil) }
        let(:grandparent) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        before do
          parent.set_child_widget(1, widget)
          grandparent.set_child_widget(1, parent)
        end

        it "returns correct parent and grandparent widgets" do
          expect(widget.parent_widget).to_not be_nil
          expect(widget.parent_widget.id).to eq parent.id
          expect(widget.parent_widget.parent_widget.id).to eq grandparent.id
        end
      end
    end

    describe "#get_web_template" do
      let(:garden_widget) { Fabricate(:garden_widget) }
      let(:cs_garden_widget) { Fabricate(:content_stripe_garden_widget) }
      let(:col_garden_widget) { Fabricate(:column_garden_widget) }

      context "has no parent" do
        let(:widget) { Fabricate.build(:widget, garden_widget: garden_widget, drop_target: drop_target) }

        it "returns drop target web template" do
          expect(widget.get_web_template).to eq page_template
        end
      end

      context "has parent" do
        let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: nil) }
        let(:parent) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        before do
          parent.set_child_widget(1, widget)
        end

        it "returns drop target web template" do
          expect(widget.get_web_template).to eq page_template
        end
      end

      context "has parent and grandparent" do
        let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: nil) }
        let(:parent) { Fabricate(:widget, garden_widget: col_garden_widget, drop_target: nil) }
        let(:grandparent) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        before do
          parent.set_child_widget(1, widget)
          grandparent.set_child_widget(1, parent)
        end

        it "returns correct parent and grandparent widgets" do
          expect(widget.get_web_template).to eq page_template
        end
      end
    end

    context "child widgets" do
      let(:garden_widget) { Fabricate(:garden_widget) }
      let(:cs_garden_widget) { Fabricate(:content_stripe_garden_widget) }
      let(:col_garden_widget) { Fabricate(:column_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget)}
      let(:other_widget) { Fabricate(:widget, garden_widget: garden_widget) }

      context "content stripe" do
        let(:cs_widget) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        before { cs_widget.set_child_widget(1, other_widget) }

        describe "#child_widgets" do
          it "returns child widgets for content stripe" do
            expect(cs_widget.child_widgets).to eq [other_widget]
          end
        end

        describe "#has_child_widget" do
          it "returns true if content stripe has child widget" do
            expect(cs_widget.has_child_widget?(other_widget)).to be_truthy
          end
        end

        describe "#get_child_widget" do
          it "returns child widget for content stripe" do
            expect(cs_widget.get_child_widget(1)).to eq other_widget
          end
        end

        describe "#set_child_widget" do
          before do
            cs_widget.set_setting(cs_widget.layout_var, 'halves')
            cs_widget.set_child_widget(2, widget)
          end
          it "sets child widget for content stripe" do
            expect(cs_widget.get_child_widget(1)).to eq other_widget
            expect(cs_widget.get_child_widget(2)).to eq widget
          end
        end
      end

      context "column" do
        let(:col_widget) { Fabricate(:widget, garden_widget: col_garden_widget, drop_target: drop_target) }
        before { col_widget.set_child_widget(1, other_widget) }

        describe "#child_widgets" do
          it "returns child widgets for content stripe" do
            expect(col_widget.child_widgets).to eq [other_widget]
          end
        end

        describe "#has_child_widget" do
          it "returns true if content stripe has child widget" do
            expect(col_widget.has_child_widget?(other_widget)).to be_truthy
          end
        end

        describe "#get_child_widget" do
          it "returns child widget for content stripe" do
            expect(col_widget.get_child_widget(1)).to eq other_widget
          end
        end

        describe "#set_child_widget" do
          before do
            col_widget.set_setting(col_widget.layout_var, 'two')
            col_widget.set_child_widget(2, widget)
          end
          it "sets child widget for content stripe" do
            expect(col_widget.get_child_widget(1)).to eq other_widget
            expect(col_widget.get_child_widget(2)).to eq widget
          end
        end
      end
    end
  end
end

