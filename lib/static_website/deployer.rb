require "static_website/compiler"

module StaticWebsite
  class Deployer
    attr_reader :website, :compile_path, :retries

    def initialize(website)
      @website = website
      @compile_path = website.compile_path
      @retries = 0
    end

    def deploy
      @retries = 0
      begin
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

    def take_db_snapshot
      GithubHerokuDeployer.heroku_run("APP=#{ENV['HEROKU_APP_NAME']} DATABASE=DATABASE_URL S3_BUCKET_PATH=#{find_or_create_s3_bucket.name} /app/bin/backup.sh -ag5-backups-manager", {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''})
    end
    
    def find_or_create_s3_bucket
      unless AWS.s3.buckets["pgbackups.#{Client.first.urn}"].exists?
        AWS.s3.buckets.create("pgbackups.#{Client.first.urn}")
      end
      AWS.s3.buckets["pgbackups.#{Client.first.urn}"]
    end

  end
end

