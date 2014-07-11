require "spec_helper"

describe StaticWebsite::Deployer do
  let!(:client) { Fabricate(:client) }
  let(:website) { Fabricate(:website).decorate }
  let(:subject) { StaticWebsite::Deployer.new(website) }

  describe "#deploy" do
    it "asks the deployer website" do
      subject.deployer.stub(:deploy)
      subject.deployer.should_receive(:deploy).with(subject.deployer_options).once
      subject.deploy
    end

    describe "when an exception is raised" do
      it "retries 0 times when Exception" do
        subject.deployer.stub(:deploy).and_raise(Exception)
        expect { subject.deploy }.to raise_error(Exception)
        expect(subject.retries).to eq 0
      end

      it "retries 3 times when GithubHerokuDeployer::CommandException" do
        subject.deployer.stub(:deploy).and_raise(GithubHerokuDeployer::CommandException)
        expect { subject.deploy }.to raise_error(GithubHerokuDeployer::CommandException)
        expect(subject.retries).to eq 3
      end

      it "retries 3 times when Heroku::API::Errors::ErrorWithResponse" do
        skip("Not sure how to raise Heroku::API::Errors::ErrorWithResponse due to change in heroku-api gem") do
          subject.deployer.stub(:deploy).and_raise(Heroku::API::Errors::ErrorWithResponse.new(nil, nil))
          expect { subject.deploy }.to raise_error(Heroku::API::Errors::ErrorWithResponse)
          expect(subject.retries).to eq 3
        end
      end
    end
  end

  describe "#deployer" do
    it "is a github heroku deployer obejct" do
      expect(subject.deployer).to be GithubHerokuDeployer
    end
  end

  describe "#deployer_options" do
    it "sets github_repo" do
      expect(subject.deployer_options).to include(github_repo: website.github_repo)
    end

    it "sets heroku_app_name" do
      expect(subject.deployer_options).to include(heroku_app_name: website.heroku_app_name)
    end

    it "sets heroku_repo" do
      expect(subject.deployer_options).to include(heroku_repo: website.heroku_repo)
    end
  end

end
