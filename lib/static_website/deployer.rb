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
      write_to_loggers("Deploy called with #{[@website, @compile_path, @user_email]}")
      @retries = 0
      begin
        deploy_repos
      rescue GithubHerokuDeployer::CommandException, Heroku::API::Errors::ErrorWithResponse => e
        write_to_loggers("Try failed with: " + e.to_s)
        raise e unless should_retry?
        increment_retries
        retry
      rescue => e
        write_to_loggers("Try failed with: " + e.to_s)
      else
        write_to_loggers("Taking db snapshot")
        take_db_snapshot
      ensure
        write_to_loggers("Cleaning up")
        clean_up
      end
    end

    def deployer
      @deployer ||= GithubHerokuDeployer
    end

    def deployer_options
      { github_repo: @website.github_repo,
        heroku_app_name: @website.heroku_app_name,
        heroku_repo: @website.heroku_repo,
        git_url: @website.github_repo,
        name: @website.heroku_app_name,
        heroku_organization_name: @website.client.organization
      }
    end

    def deploy_repos
      write_to_loggers("About to deploy with options")
      deployer.deploy(deployer_options) do |repo|
        write_to_loggers("calling cp_r_compile_path(repo)")
        cp_r_compile_path(repo)
      end
    end

    def cp_r_compile_path(repo)
      # save repo dir so we can remove it later
      @repo_dir = repo.dir.to_s
      write_to_loggers("Repo dir: #{@repo_dir}")

      # copy static website into repo
      copy_to_repo
      commit_to_repo
    end

    def copy_to_repo
      write_to_loggers("running fileutils.cp_r with: #{compile_path} + '/.' + #{@repo_dir}")
      FileUtils.cp_r(compile_path + "/.", @repo_dir)
      FileUtils.cp_r(File.join(Rails.root, "public", "javascripts") + "/.", @repo_dir + "/javascripts")
      FileUtils.mkdir(File.join(@repo_dir, "assets"))
      FileUtils.cp(File.join(Rails.root, "public", "area_page.js"), @repo_dir + "/javascripts/area_page.js")
    end

    def commit_to_repo
      commit_all_pages_to_repo

      Rails.logger.debug("git config name, email")
      repo.config('user.name', ENV['HEROKU_APP_NAME'])
      repo.config('user.email', ENV['HEROKU_APP_NAME'])
      # commit changes
      repo.add('.')
      Rails.logger.debug("git committing all")
      repo.commit_all "Add compiled site"
    end

    def commit_all_pages_to_repo
      helper = ActionController::Base.helpers
      area_page_css_path = File.join(Rails.root, 'public', helper.asset_path("area_page.css"))
      area_page_css_destination_path = @repo_dir + helper.asset_path('area_page.css')
      write_to_loggers("running fileutils.cp_r with: #{area_page_css_path} : #{area_page_css_destination_path}")
      FileUtils.cp_r(area_page_css_path, area_page_css_destination_path)
    end

    def should_retry?
      @retries < 3
    end

    def increment_retries
      @retries += 1
    end

    def clean_up
      write_to_loggers("Removing directory: #{@repo_dir} if exists")
      FileUtils.rm_rf(@repo_dir) if @repo_dir && Dir.exists?(@repo_dir)
    end

    private

    def take_db_snapshot
      SavesManager.new(@user_email).save
    end
  end
end

