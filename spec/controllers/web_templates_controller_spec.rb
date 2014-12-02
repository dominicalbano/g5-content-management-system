require 'spec_helper'

describe WebTemplatesController do
  let!(:location) { Fabricate(:location, urn: urn) }
  let(:urn) { "foo" }
  let(:params) do
    {
      urn: urn,
      vertical_slug: "apartments",
      state_slug: "or",
      city_slug: "bend"
    }
  end

  describe "#show" do
    it "renders preview without being signed in" do
      get :show, params
      response.should render_template(:show)
    end
  end
end
