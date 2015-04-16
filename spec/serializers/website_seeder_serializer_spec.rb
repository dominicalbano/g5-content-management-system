require 'spec_helper'

describe WebsiteSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }

  let(:garden_web_layout) { Fabricate(:garden_web_layout, name: 'web layout') }
  let(:web_layout) { Fabricate(:web_layout, garden_web_layout: garden_web_layout) }
  let(:garden_web_theme) { Fabricate(:garden_web_theme, name: 'web theme') }
  let(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let(:drop_targets) { [ Fabricate(:drop_target), Fabricate(:drop_target) ] }

  let(:web_template) { Fabricate(:website_template, website: website, web_layout: web_layout, web_theme: web_theme, drop_targets: drop_targets)}
  let(:web_home_template) { Fabricate(:web_home_template, website: website) }
  let(:web_page_templates) do
    [
      Fabricate(:web_page_template, website: website),
      Fabricate(:web_page_template, website: website)
    ]
  end

  subject { WebsiteSeederSerializer.new(location).as_json(root: false) }

  describe "#as_json" do
    before do
      web_home_template.reload
      web_page_templates.each(&:reload)
      web_template.reload
      website.reload
      location.reload
      @response = subject
    end

    it "serializes the website template" do
      expect(@response[:website_template]).to_not be_nil
      expect(@response[:website_template][:name]).to eq web_template.name
    end

    it "serializes the web home template" do
      expect(@response[:web_home_template]).to_not be_nil
      expect(@response[:web_home_template][:name]).to eq web_home_template.name
    end

    it "serializes all the web page templates" do
      expect(@response[:web_page_templates]).to_not be_nil
      expect(@response[:web_page_templates].size).to eq web_page_templates.size
      expect(@response[:web_page_templates].first[:name]).to eq web_page_templates.first.name
    end
  end

  describe "#to_yaml_file" do
    ## TODO: write this spec
  end
end