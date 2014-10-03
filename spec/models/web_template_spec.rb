require 'spec_helper'

describe WebTemplate do
  let(:location) { Fabricate.build(:location) }
  let(:website) { Fabricate.build(:website, owner: location) }
  let(:web_template) { Fabricate.build(:web_template, website: website) }

  describe "validations" do
    it "has a valid fabricator" do
      Fabricate.build(:web_template).should be_valid
    end
    it "requires name" do
      Fabricate.build(:web_template, name: "").should be_invalid
    end
    it "require title" do
      Fabricate.build(:web_template, title: "").should be_invalid
    end
    it "does not require slug, because creates from title" do
      Fabricate.build(:web_template, slug: "").should be_valid
    end
  end

  describe "callbacks" do
    before do 
      web_template.save
    end
      
    context "set_navigation_setting" do
      it "updates" do
        expect(web_template).to receive(:update_navigation_settings)
        web_template.update_attribute(:in_trash, true)
      end  

      it "enqueues a worker" do
        expect(Resque).to receive(:enqueue).with(UpdateNavigationSettingsJob, website.id)
        web_template.update_attribute(:in_trash, true)
      end  

      it "skips" do
        expect(web_template).to_not receive(:update_navigation_settings)
        web_template.update_attributes(in_trash: true, should_skip_update_navigation_settings: true)
      end 
    end  
  end  

  describe "#web_layout" do
    it { web_template.should respond_to :web_layout }
  end

  describe "#web_theme" do
    it { web_template.should respond_to :web_theme }
  end

  describe "#widgets" do
    it { web_template.should respond_to :widgets }
  end

  describe "#stylesheets" do
    it "has a collection of stylesheets" do
      web_template.stylesheets.should be_kind_of(Array)
    end
  end

  describe "#javascripts" do
    it "has a collection of javascripts" do
      web_template.javascripts.should be_kind_of(Array)
    end
  end

  describe "#stylesheet_link_paths" do
    it "has a collection of stylesheets link paths" do
      web_template.stylesheet_link_paths.should be_kind_of(Array)
    end
  end

  describe "#url" do
    let!(:client) { Fabricate(:client, type: type) }
    let(:multi_domain_formatter) { double(format: nil) }
    let(:single_domain_formatter) { double(format: nil) }

    before do
      URLFormat::SingleDomainFormatter.stub(new: single_domain_formatter)
      URLFormat::MultiDomainFormatter.stub(new: multi_domain_formatter)
      web_template.url
    end

    context "single domain client" do
      let(:type) { "SingleDomainClient"}

      it "calls the correct formatter" do
        expect(single_domain_formatter).to have_received(:format)
      end
    end

    context "multi domain client" do
      let(:type) { "MultiDomainClient"}

      it "calls the correct formatter" do
        expect(multi_domain_formatter).to have_received(:format)
      end
    end
  end

  describe "#last_mod" do
    let!(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
    let!(:widget) do
      Fabricate(:widget, drop_target: drop_target, updated_at: Time.now - 2.days)
    end

    context "a template with widgets" do
      it "gets the date from it's last widget" do
        expect(web_template.last_mod).to eq(widget.updated_at.to_date)
      end
    end

    context "a template with no widgets" do
      before { web_template.stub(widgets: []) }

      it "gets the date from itself" do
        expect(web_template.last_mod).to eq(web_template.updated_at.to_date)
      end
    end
  end

  describe "#body_class" do
    subject { web_template.body_class }

    context "home home template" do
      let(:web_template) { Fabricate.build(:web_home_template) }

      it { should eq("web-home-template") }
    end

    context "home page template" do
      let(:web_template) { Fabricate.build(:web_page_template) }

      it { should eq("web-page-template") }
    end
  end

  describe "#location_body_class" do
    subject { web_template.location_body_class }

    context "a website owned by a location" do
      context "non corporate location" do
        it { should eq("site-location") }
      end

      context "corporate location" do
        let(:location) { Fabricate(:location, corporate: true) }

        it { should eq("site-corporate") }
      end
    end

    context "a website owned by a client" do
      let(:client) { Fabricate.build(:client) }
      let(:website) { Fabricate.build(:website, owner: client) }

      it { should eq("site-location") }
    end
  end

  describe "page hierarchy" do
    let!(:client) {Fabricate(:client)}
    let!(:web_template) { Fabricate(:web_home_template) }

    it "should respond to child_templates" do
      web_template.should respond_to :children
    end

    context "without children" do
      it "should return an empty array" do
        expect(web_template.children).to be_empty
      end
    end

    context "with child templates" do
      let!(:child_template) {Fabricate(:web_page_template, parent_id: web_template.id)}
      let!(:other_template) {Fabricate(:web_page_template, parent_id: nil)}

      it "should return an array of child templates" do
        expect(web_template.children).to eq([child_template])
      end

      describe ".top_level pages (with no parent references)" do
        it "should return top level templates" do
          expect(WebTemplate.top_level).to match_array [web_template, other_template]
        end
      end

    end
  end
end

