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
      LOGGERS.each {|logger| logger.debug("Deploy called with #{[@website, @compile_path, @user_email]}")}
      @retries = 0
      begin
        LOGGERS.each {|logger| logger.debug("About to deploy with options")}
        deployer.deploy(deployer_options) do |repo|
          LOGGERS.each{|logger| logger.debug("calling cp_r_compile_path(repo)")}
          cp_r_compile_path(repo)
        end
      rescue GithubHerokuDeployer::CommandException,
             Heroku::API::Errors::ErrorWithResponse => e
        LOGGERS.each{|logger| logger.debug("Try failed with: " + e.to_s)}
        if should_retry?
          increment_retries
          retry
        else
          raise e
        end
      rescue => e
        LOGGERS.each{|logger| logger.debug("Try failed with: " + e.to_s)}
      else
        LOGGERS.each{|logger| logger.debug("Taking db snapshot")}
        take_db_snapshot
      ensure
        LOGGERS.each{|logger| logger.debug("Cleaning up")}
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

    def cp_r_compile_path(repo)
      # save repo dir so we can remove it later
      @repo_dir = repo.dir.to_s
      LOGGERS.each{|logger| logger.debug("Repo dir: #{@repo_dir}")}

      # copy static website into repo
      LOGGERS.each{|logger| logger.debug("running fileutils.cp_r with: #{compile_path} + '/.' + #{@repo_dir}")}
      FileUtils.cp_r(compile_path + "/.", @repo_dir)
      # copy public javascripts into repo
      FileUtils.cp_r(File.join(Rails.root, "public", "javascripts") + "/.", @repo_dir + "/javascripts")
      FileUtils.cp(File.join(Rails.root, "public", "area_page.js"), @repo_dir + "/javascripts/area_page.js")

      LOGGERS.each{|logger| logger.debug("copying area page styles from: #{File.join(Rails.root, ActionController::Base.helpers.asset_path('area_page.css'))} to: #{@repo_dir + ActionController::Base.helpers.asset_path('area_page.css')}")}

      FileUtils.cp(File.join(Rails.root, ActionController::Base.helpers.asset_path("area_page.css")), @repo_dir + ActionController::Base.helpers.asset_path('area_page.css'))

      Rails.logger.debug("git config name, email")
      repo.config('user.name', ENV['HEROKU_APP_NAME']) 
      repo.config('user.email', ENV['HEROKU_APP_NAME']) 

      # commit changes
      repo.add('.')
      Rails.logger.debug("git committing all")
      repo.commit_all "Add compiled site"
    end

    def should_retry?
      @retries < 3
    end

    def increment_retries
      @retries += 1
    end

    def clean_up
      LOGGERS.each{|logger| logger.debug("Removing directory: #{@repo_dir} if exists")}
      FileUtils.rm_rf(@repo_dir) if @repo_dir && Dir.exists?(@repo_dir)
    end

    private

    def take_db_snapshot
      SavesManager.new(@user_email).save
    end
  end
end

