require "spec_helper"

describe WebTemplateCloner do
  let(:web_template_cloner) { WebTemplateCloner.new(source_location, target_location) }
  let(:template) { Fabricate(:web_template) }
  let(:target_website) { Fabricate(:website) }

  describe "#clone" do
  end
end
