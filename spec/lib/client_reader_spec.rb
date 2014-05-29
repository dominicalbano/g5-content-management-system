require "spec_helper"

describe ClientReader do
  let(:client_reader) { described_class.new(client_uid) }
  let(:client_uid) { "#{Rails.root}/spec/support/client.html" }
  let(:uf2_client) { Microformats2.parse(client_uid) }
  let(:parsed) { double(first: uf2_client.first) }

  describe "#perform" do
    before { Microformats2.stub(parse: parsed) }

    subject { client_reader.perform }

    describe "client destruction" do
      after { subject }

      context "no existing clients" do
        it "does nothing" do
          expect(Client).to_not receive(:destroy_all)
        end
      end

      context "an existing client" do
        context "a client that matches the uid" do
          before { Fabricate(:client, uid: client_uid) }

          it "does nothing" do
            expect(Client).to_not receive(:destroy_all)
          end
        end

        context "a client that does not match the uid" do
          before { Fabricate(:client, uid: "foo") }

          it "destroys the client" do
            expect(Client).to receive(:destroy_all)
          end
        end
      end
    end

    describe "client creation" do
      it "saves the client" do
        expect { subject }.to change { Client.all.size }.from(0).to(1)
      end

      describe "specific client data" do
        subject(:client) { Client.first }

        before { client_reader.perform }

        its([:name]) { should eq("Farmhouse") }
        its([:vertical]) { should eq("Apartments") }
        its([:type]) { should eq("MultiDomainClient") }
        its([:domain]) { should eq("http://farmhouseapartments.com/") }
      end
    end

    describe "client processing" do
      it "creates locations for each u2f location" do
        expect { subject }.to change { Location.all.size }.from(0).to(2)
      end

      describe "specific location data" do
        subject(:location) { Location.first }

        before { client_reader.perform }

        its([:urn]) { should eq("g5-cl-1qrcyt46-hollywood") }
        its([:name]) { should eq("Hollywood") }
        its([:domain]) { should eq("http://www.hollywood.com/") }
        its([:street_address]) { should eq("4567 Storage Drive Unit 5") }
        its([:state]) { should eq("CA") }
        its([:city]) { should eq("Hollywood") }
        its([:postal_code]) { should eq("80229") }
        its([:phone_number]) { should eq("555-555-5555") }
        its([:corporate]) { should be_false }
        its([:neighborhood]) { should eq('Westwood')}
        its([:floor_plans]) { should eq('2 Bedroom 2 Bath, Studio')}
        its([:primary_amenity]) { should eq('Secret Passages')}
        its([:qualifier]) { should eq('Luxury')}
        its([:primary_landmark]) { should eq('Seattle Grace Hospital')}
      end
    end

    describe "location cleanup" do
      let!(:rogue_location) { Fabricate(:location) }

      before { subject }

      it "destroys the rougue location" do
        expect(Location.all).to_not include(rogue_location)
      end

      it "does not destroy valid locations" do
        expect(Location.all.size).to eq(2)
      end
    end
  end
end
