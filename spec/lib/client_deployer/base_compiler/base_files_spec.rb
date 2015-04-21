require "spec_helper"

describe ClientDeployer::BaseCompiler::BaseFiles do
  let!(:client) { Fabricate(:client) }
  let(:website) { Fabricate(:website) }
  let(:htaccess) { double(compile: nil) }
  let(:robots) { double(compile: nil) }

  before do
    ClientDeployer::BaseCompiler::HTAccess.stub(new: htaccess)
    ClientDeployer::BaseCompiler::Sitemap.stub(new: sitemap)
    ClientDeployer::BaseCompiler::Robots.stub(new: robots)
  end

  describe "#compile" do
    let(:subject) { described_class.new(website) }

    before { subject.compile }

    it "compiles htaccess" do
      expect(htaccess).to have_received(:compile)
    end

    it "compiles robots" do
      expect(robots).to have_received(:compile)
    end
  end
end
