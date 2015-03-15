require "spec_helper"

describe Widget, vcr: VCR_OPTIONS do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:web_template) { Fabricate(:web_page_template, website: website)}
  let(:drop_target) { Fabricate(:drop_target, web_template: web_template) }

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
    let(:garden_widget) { Fabricate(:garden_widget, settings: [name: "foo"]) }
    let(:widget) { Fabricate(:widget, garden_widget: garden_widget) }
    let(:setting) { widget.settings.first }

    it "accepts nested attributes for settings" do
      widget.update_attributes(settings_attributes: {
        id: setting.id,
        name: "TEST"
      })
      expect(setting.name).to eq "TEST"
    end
  end

  describe "#render_show_html" do
    context "content stripe widget" do
      let(:garden_widget) { Fabricate(:row_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:row_widget_show_html) { double(render: nil) }

      before { RowWidgetShowHtml.stub(new: row_widget_show_html) }

      it "calls render on RowWidgetShowHtml" do
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
    let(:widget) {Fabricate.create(:widget,
                                   {garden_widget: garden_widget})}
    let(:garden_widget) {Fabricate.create(:garden_widget,
                                 {  show_stylesheets: ["foo.css", "bar.css"],
                                    show_javascript: "show.js",
                                    lib_javascripts: ["a.js", "b.js"] })}
    let!(:setting) { Fabricate.create(:setting,
                                     {name: 'row_1_widget_id',
                                      value: widget.id,
                                      owner: row_widget}) }
    let(:row_widget) {Fabricate.create(:widget).reload}


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

    describe "#widgets" do
      it "returns associated child widgets" do
        expect(row_widget.widgets).to eq([widget])
      end
    end

    it "#widget_type" do
      expect(widget.widget_type).to eq(garden_widget.widget_type)
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
          expect(widget.liquid_parameters['web_template_name']).to eq(web_template.name)
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
      let(:cs_garden_widget) { Fabricate(:row_garden_widget) }
      let(:col_garden_widget) { Fabricate(:column_garden_widget) }

      before { setting.destroy } #remove faux setting
      
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
          parent.set_nested_widget(1, widget)
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
          parent.set_nested_widget(1, widget)
          grandparent.set_nested_widget(1, parent)
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
      let(:cs_garden_widget) { Fabricate(:row_garden_widget) }
      let(:col_garden_widget) { Fabricate(:column_garden_widget) }

      before { setting.destroy } #remove faux setting - use WidgetFabricator defaults only
      
      context "has no parent" do
        let(:widget) { Fabricate.build(:widget, garden_widget: garden_widget, drop_target: drop_target) }

        it "returns drop target web template" do
          expect(widget.get_web_template).to eq web_template
        end
      end

      context "has parent" do
        let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: nil) }
        let(:parent) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        before do
          parent.set_setting('column_one_widget_name', widget.name)
          parent.set_setting('column_one_widget_id', widget.id)
        end

        it "returns drop target web template" do
          expect(widget.get_web_template).to eq web_template
        end
      end

      context "has parent and grandparent" do
        let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: nil) }
        let(:parent) { Fabricate(:widget, garden_widget: col_garden_widget, drop_target: nil) }
        let(:grandparent) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
        before do
          parent.set_setting('row_one_widget_name', widget.name)
          parent.set_setting('row_one_widget_id', widget.id)
          grandparent.set_setting('column_one_widget_name', parent.name)
          grandparent.set_setting('column_one_widget_id', parent.id)
        end

        it "returns correct parent and grandparent widgets" do
          expect(widget.get_web_template).to eq web_template
        end
      end
    end
  end
end

