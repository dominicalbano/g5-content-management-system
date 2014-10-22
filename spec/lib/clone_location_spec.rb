require 'rspec'

describe CloneLocation, vcr: VCR_OPTIONS do
  let!(:client) { Fabricate(:client) }
  let(:website) { Fabricate(:website) }
  let(:website_template) { Fabricate(:website_template) }
  let(:web_layout) { Fabricate(:web_layout) }
  let(:web_theme) { Fabricate(:web_theme) }
  let(:web_home_template) { Fabricate(:web_home_template) }
  let(:drop_target) { Fabricate(:drop_target, html_id: "drop-target-aside") }
  let(:widget) { Fabricate(:widget) }
  let(:renderer) { double(render: "Foo") }

  before :each do
    web_home_template.stub(:update_navigation_settings)
    AreaPageRenderer.stub(new: renderer)
    website.website_template = website_template
    website_template.web_layout = web_layout
    website_template.web_theme = web_theme
    website.web_home_template = web_home_template
    web_home_template.drop_targets << drop_target
    drop_target.widgets << widget
  end


  describe '#clone_location' do
    let(:locations) { [Fabricate(:location)] }
    let(:area) { "Bend, Oregon" }
    let(:preview) { helper.area_preview(web_layout, web_home_template, locations, area) }

    it 'should clone loc_a to _loc_b' do

      true.should == false

    end
  end

  describe '#remove_widget' do
    before :each do
      let(:widgeta) { Fabricate(:widget) }


    end

    it 'a widget should remove all of its child widgets' do
      true.should == false
    end

    it 'a widget should remove itself' do
      true.should == false
    end
  end
end