require 'spec_helper'

describe WebPageTemplateSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:web_page_template) { Fabricate(:web_page_template, website: website)}
  let!(:drop_targets) do
    [ 
      Fabricate(:drop_target, web_template: web_page_template), 
      Fabricate(:drop_target, web_template: web_page_template) 
    ]
  end
  let!(:garden_widget) { Fabricate(:garden_widget) }

  subject { WebPageTemplateSeederSerializer.new(web_page_template).as_json(root: false) }

  describe "#as_json" do
    it "serializes the name" do
      expect(subject[:name]).to eq web_page_template.name
    end

    it "serializes the title" do
      expect(subject[:title]).to eq web_page_template.title
    end

    it "serializes the drop targets" do
      expect(subject[:drop_targets].size).to eq(2)
      expect(subject[:drop_targets].first[:html_id]).to eq(drop_targets.first.html_id)
    end
  end

  describe "#to_yaml_file" do
    ## TODO: write this spec
  end
end