require "static_website/compiler"

LOGGERS = [Rails.logger, Resque.logger] unless defined? LOGGERS

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
      LOGGERS.each {|logger| logger.info("Deploy called with #{[@website, @compile_path, @user_email]}")}
      @retries = 0
      begin
        LOGGERS.each {|logger| logger.info("About to deploy with options")}
        deployer.deploy(deployer_options) do |repo|
          
          LOGGERS.each{|logger| logger.info("calling cp_r_compile_path(repo)")}
          cp_r_compile_path(repo)
        end
      rescue GithubHerokuDeployer::CommandException,
             Heroku::API::Errors::ErrorWithResponse => e
        LOGGERS.each{|logger| logger.info("Try failed with: " + e.to_s)}
        if should_retry?
          increment_retries
          retry
        else
          raise e
        end
      rescue => e
        LOGGERS.each{|logger| logger.info("Try failed with: " + e.to_s)}
      else
        LOGGERS.each{|logger| logger.info("Taking db snapshot")}
        take_db_snapshot
      ensure
        LOGGERS.each{|logger| logger.info("Cleaning up")}
        clean_up
      end
    end

    def deployer
      @deployer ||= GithubHerokuDeployer
    end

    def deployer_options
      {
          github_repo: source_repo,
        heroku_app_name: @website.heroku_app_name,
        heroku_repo: @website.heroku_repo,
        git_url: @website.github_repo,
        name: @website.heroku_app_name,
        heroku_organization_name: @website.client.organization
      }
    end

    def copy_path
      if website.single_domain_location?
        Client.first.website.compile_path
      else
        compile_path
      end
    end

    def source_repo
      #TODO: Test this for an app that has never been deployed before.
      @website.heroku_repo
    end

    def cp_r_compile_path(repo)
      # save repo dir so we can remove it later
      @repo_dir = repo.dir.to_s
      LOGGERS.each{|logger| logger.info("Repo dir: #{@repo_dir}")}

      # copy static website into repo
      LOGGERS.each{|logger| logger.info("running fileutils.cp_r with: #{copy_path} + '/.' + #{@repo_dir}")}
      FileUtils.cp_r(copy_path + "/.", @repo_dir)

      if website.owner.corporate?
        FileUtils.mkdir(File.join(@repo_dir, "assets"))
        FileUtils.cp(File.join(Rails.root, "public", "area_page.js"), @repo_dir + "/javascripts/area_page.js")
        area_page_css_path = File.join(Rails.root, 'public', ActionController::Base.helpers.asset_path("area_page.css"))
        area_page_css_destination_path = @repo_dir + ActionController::Base.helpers.asset_path('area_page.css')
        LOGGERS.each{|logger| logger.info("running fileutils.cp_r with: #{area_page_css_path} : #{area_page_css_destination_path}")}
        FileUtils.cp_r(area_page_css_path, area_page_css_destination_path)
      end

      Rails.logger.debug("git config name, email")
      repo.config('user.name', ENV['HEROKU_APP_NAME']) 
      repo.config('user.email', ENV['HEROKU_APP_NAME'])

      # Update deploy date. Useful to make sure our commit pushes
      File.open(File.join(@repo_dir, '.publish_timestamp'), 'w') { |file| file.write(DateTime.now) }

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
      LOGGERS.each{|logger| logger.info("Removing directory: #{@repo_dir} if exists")}
      FileUtils.rm_rf(@repo_dir) if @repo_dir && Dir.exists?(@repo_dir)
    end

    private

    def take_db_snapshot
      SavesManager.new(@user_email).save
    end
  end
end

