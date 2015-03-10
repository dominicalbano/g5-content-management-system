require "spec_helper"

describe Seeder::DropTargetSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:website_template) { Fabricate(:website_template, website: website) }
  let(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/defaults/websites/defaults.yml")) }
  let(:instructions) { defaults[:website_template][:drop_targets] }
  let(:seeder) { Seeder::DropTargetSeeder.new(website_template, instructions) }

  describe "#seed" do
    let(:drop_targets_count) { instructions.size }
    let(:drop_target_first) { instructions.first }
    let(:drop_target_first_count) { drop_target_first[:widgets].size }
    subject { seeder.seed }

    context "valid instructions" do
      before { subject }

      it "creates drop targets from instructions" do
        expect(website_template.drop_targets.size).to eq(drop_targets_count)
      end
    end

    context "no instructions" do
      let(:instructions) { nil }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end

    context "no website template" do
      let(:website_template) { nil }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end

    context "empty instructions" do
      let(:instructions) { [] }
      it "creates no drop targets" do
        expect(website_template.drop_targets.size).to eq(0)
      end
    end

    context "no html id in instructions" do
      before { instructions.each { |i| i.except!(:html_id) } }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end

    context "no widgets in instructions" do
      before { instructions.each { |i| i.except!(:widgets) } }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end
  end

  describe "#create_widgets" do
    let(:drop_target) { Fabricate(:drop_target) }
    let(:widget_instructions) { instructions.first[:widgets] }
    let(:widget_count) { widget_instructions.size }
    subject { seeder.create_widgets(drop_target, widget_instructions) }

    context "drop target has widgets" do
      before { subject }
      it "creates widgets for drop target" do
        expect(drop_target.widgets.size).to eq(widget_count)
      end
    end

    context "drop target has empty widgets" do
      let(:widget_instructions) { [] }
      it "creates no widgets for drop target" do
        expect(drop_target.widgets.size).to eq(0)
      end
    end
  end
end