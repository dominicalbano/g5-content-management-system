require 'spec_helper'

describe WebsiteTemplateSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }

  let(:garden_web_layout) { Fabricate(:garden_web_layout, name: 'web layout') }
  let(:web_layout) { Fabricate(:web_layout, garden_web_layout: garden_web_layout) }
  let(:garden_web_theme) { Fabricate(:garden_web_theme, name: 'web theme') }
  let(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let(:drop_targets) { [ Fabricate(:drop_target), Fabricate(:drop_target) ] }

  let(:web_template) { Fabricate(:web_template, website: website, web_layout: web_layout, web_theme: web_theme, drop_targets: drop_targets)}

  subject { WebsiteTemplateSeederSerializer.new(web_template).as_json(root: false) }

  describe "#as_json" do
    it "serializes the name" do
      expect(subject[:name]).to eq web_template.name
    end

    it "serializes the web layout" do
      expect(subject[:web_layout][:slug]).to eq garden_web_layout.slug
    end

    it "serializes the web layout" do
      expect(subject[:web_theme][:slug]).to eq garden_web_theme.slug
    end

    it "serializes the drop targets" do
      expect(subject[:drop_targets].size).to eq drop_targets.size
      expect(subject[:drop_targets].first[:html_id]).to eq drop_targets.first.html_id
    end
  end
end