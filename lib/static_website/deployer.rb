require "heroku-api"
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
      LOGGERS.each {|logger| logger.info("Deploy called with #{[@website, @compile_path, @user_email]}")}
      @retries = 0
      begin
        #deployer.create(deployer_options)
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
          heroku_organization_name: @website.client.organization,
          #TODO CKE: Testing Hack
          id_rsa: "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEAykR009Xs//GxFItPfN6IaMH3Tsjvl/kW5mLUA0aWU/FdDJ2c\nc+zG9tLnxpL6k2yf2SrKb6sNkhafuq0uB5RBH+FniWxIbC6iqceCg+jBkAkqjahP\nOJX2SRAS86E30llNJ7VFcmVRnED+qAGuGSs7v8H2SmhXErntIpttsMYb16IU8h23\nTUsc3C3sWJrZQpolxwc7gvZ2BAcKknipf15Trnyy8Xyh7pQUNpG/4GuylmMU/zJb\ny8IsxcLIvNvYoPsvDRd0ovRfdUiTbJg3rVWN1KEY0K5fwz5DhAYUmTXDWLwXzlu9\nZ9aqzhFFrEK7JBkmkBRGG+7g6nWPi1FzCYzYpwIDAQABAoIBAQDA1e0PvOdbyAAM\nVxisMriYLzxpR1ZtbBPyB4ybpuNRGk6c5XKwbq/tx3sjLSNqA+iNsacYOVsRyTH1\nVoAIx8Yi79G3CZ4uTXPVK5l5yyEnAiYosar9hrMsSv/WeABxMaRGVCLmgkQBFVHz\nuM5Tvo0TL4dwvvMsrkevc8FrBCStOWv/BLGRGYUiCrs+1jBXiGySmiz+bamyKryz\ntZnFIqPxXyNSYcvMn/i0lx4a0VCJl2R0ExUgnl5rXNeFFnM75NvsBpebmpXQVky6\n7+feXQHYalxW0gL0i6A8zTK3cmRSujmq01WOJsUcEoQ2RgoT1U4JigI9BlfAA6ch\n63wyaEGRAoGBAP3yeh7ghuDJzA3kDic/BGFkGKPHl3hFq4cCHnHxUF/qgjYkb0/e\ncJt3D42afEupSY+rRn6JCVoK+sTORVsp4Z4PZ32K20Ewq4k2HcPlky1q9Q6yQS9K\n+F9sN8o5wHM96WH7rKKlvW4dYwZdQRGHT0fLWlJVxjD6AFqhQX10t0A5AoGBAMvn\nCEIb6k0cJYcURU7uc9AVf8rkSZ2HVn/aol0Kq6iyHTias1PyMEpkxY5sso53CKPV\ngLM0ITAjxJ+R+2ZcBVKYMDPKOJIyIE6ixiycLF0BmNhNxdm9uzIuPqF6SVzZz1H5\nEBnlUj69SyNK4jXtYC6pSoEErSoX1bZuE8C8TR/fAoGAC44K7Hi+6l+EP2WPF04Q\nvvW1AU7Fn51b7qq0A+88/wBGqHwD7Jhse0ZxmLncyfyL8lOSw5Msr8IsIuRX14wS\nTgTZaqb0zwSN6ZJizFUX20swl1iZCrPYlU7xQuxZy2SXx/ORqVztP6NqrBF2Mnv7\nqYKhO3nXqMbXWUhZGIJFDFECgYEAoV/r7UZinTyVht7IK7wU9K7PQSiECqS+FNpY\nfgKf8RdmgRIOs3WOOpKeuCXW+2HB+MhU3392dL8aMqA6s7xIiiHgpFx7gVkisJmq\n9ktz4PgOm8KRv86lhQWMlAhQX6gSqPHRiG0yNm1iNkBh4ARKhyN8z7d/xTyv634b\nLALbl0kCgYEAykAqwGmgIof/h3Ch5qQRaACXn0lzwFfYTcE2nqXU1U3P8mER9iYB\nEotMdyg0EqavpodqXdXggNNw0jGTIA10+0DvP3ffG/XnobsPjLE79clIBdeCHd9a\ni/c5dohzwnd44c3GIGVsviOL9Lkd2oDNqp8ZQUK+/C8Xteqwur7/DkE=\n-----END RSA PRIVATE KEY-----\n"
      }
    end

    def single_domain_client?
      Client.first.type == "SingleDomainClient"
    end

    def copy_path
      if single_domain_client?
        Client.first.website.compile_path
      else
        compile_path
      end
    end

    def cp_r_compile_path(repo)
      # save repo dir so we can remove it later
      @repo_dir = repo.dir.to_s
      LOGGERS.each{|logger| logger.info("Repo dir: #{@repo_dir}")}

      # copy static website into repo
      LOGGERS.each{|logger| logger.info("running fileutils.cp_r with: #{compile_path} + '/.' + #{@repo_dir}")}

      FileUtils.cp_r(copy_path + "/.", @repo_dir)

      # copy public javascripts into repo
      #FileUtils.cp_r(File.join(Rails.root, "public", "javascripts") + "/.", @repo_dir + "/javascripts")
      FileUtils.cp(File.join(Rails.root, "public", "area_page.js"), @repo_dir + "/javascripts/area_page.js") if website.owner.corporate?

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

    def source_repo
      #TODO: Test this for an app that has never been deployed before.
      @website.heroku_repo
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

