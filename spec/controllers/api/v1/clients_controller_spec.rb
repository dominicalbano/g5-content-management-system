require "spec_helper"

describe Api::V1::ClientsController, :auth_controller do
  
  describe "#deploy_websites" do
    let(:client) { Fabricate(:client) }

    before(:each) do
      allow(Client).to receive(:first).and_return(client)
    end

    it "queues deploy with async deploy" do
      allow(client).to receive(:async_deploy)
      post :deploy_websites, 1
    end
  end
end
