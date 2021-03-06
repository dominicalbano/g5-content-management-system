require "spec_helper"

shared_examples_for HasManySettings do
  let(:described_instance) { described_class.new }

  it { should have_many(:settings) }
  it { should respond_to("settings_attributes=") }

  describe "#settings_names" do
    it "when no settings returns empty array" do
      described_instance.settings_names.should eq []
    end
    it "when settings returns settings names" do
      described_instance.settings = [Setting.new(name: "foo")]
      described_instance.settings_names.should eq ["foo"]
    end
  end
end

describe Client do
  it_behaves_like HasManySettings
end

describe Location do
  it_behaves_like HasManySettings
end

describe Website do
  it_behaves_like HasManySettings
end

describe WebTemplate do
  it_behaves_like HasManySettings
end

describe WebLayout do
  it_behaves_like HasManySettings
end

describe WebTheme do
  it_behaves_like HasManySettings
end

describe Widget do
  it_behaves_like HasManySettings
end
