require "static_website/compiler"

module StaticWebsite
  class Deployer
    attr_reader :website, :compile_path, :retries

    def initialize(website, user_email)
      @website = website
      @compile_path = website.compile_path
      @retries = 0
      @user_email = user_email
    end

    def deploy
      @retries = 0
      begin
        if @website.client.organization.present? && !heroku_app_created?
          Rails.logger.info "Creating #{@website.heroku_app_name} within org: #{@website.client.organization} ..."
          create_app_in_org
        end
        deployer.deploy(deployer_options) do |repo|
          cp_r_compile_path(repo)
        end
      rescue GithubHerokuDeployer::CommandException,
             Heroku::API::Errors::ErrorWithResponse => e
        Rails.logger.info("Try failed with: " + e.to_s)
        if should_retry?
          increment_retries
          retry
        else
          raise e
        end
      else
        take_db_snapshot
      ensure
        clean_up
      end
    end

    def deployer
      @deployer ||= GithubHerokuDeployer
    end

    def deployer_options
      { github_repo: @website.github_repo,
        heroku_app_name: @website.heroku_app_name,
        heroku_repo: @website.heroku_repo }
    end

    def cp_r_compile_path(repo)
      # save repo dir so we can remove it later
      @repo_dir = repo.dir.to_s

      # copy static website into repo
      FileUtils.cp_r(compile_path + "/.", @repo_dir)
      # copy public javascripts into repo
      FileUtils.cp_r(File.join(Rails.root, "public", "javascripts") + "/.", @repo_dir + "/javascripts")
      FileUtils.cp(File.join(Rails.root, "public", "area_page.js"), @repo_dir + "/javascripts/area_page.js")

      # commit changes
      repo.add('.')
      repo.commit_all "Add compiled site"
    end

    def should_retry?
      @retries < 3
    end

    def increment_retries
      @retries += 1
    end

    def clean_up
      FileUtils.rm_rf(@repo_dir) if @repo_dir && Dir.exists?(@repo_dir)
    end

    private

    def create_app_in_org
      heroku_platform_api.organization_app.create(platform_api_options)
    end

    def take_db_snapshot
      SavesManager.new(@user_email).save
    end

    def heroku_platform_api
      @heroku_platform_api ||= PlatformAPI.connect_oauth("#{ENV['HEROKU_API_KEY']}")
    end

    def platform_api_options
      { git_url: @website.github_repo,
        name: @website.heroku_app_name,
        organization: @website.client.organization
      }
    end

    def heroku_app_created?
      heroku_platform_api.organization_app.list_for_organization(@website.client.organization).select {
        |orgapp| orgapp["name"] == @website.heroku_app_name
      }.count > 0
    end
  end
end

