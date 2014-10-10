class SavesManager
  FOLDER_NAME = "db-backups"

  def initialize(user_email)
    @user_email = user_email
  end


  def fetch_all
    items = bucket_target_branch.select do |object|
      object.key if object.key =~ /.+\.dump\z/
    end.map do |object|
      { id: object.key.rpartition('.').first,
        created_at: object.last_modified }
    end.sort {|a,b| b[:created_at] <=> a[:created_at]}
  rescue => e
    Rails.logger.warn e.message
    []
  end

  def save
    GithubHerokuDeployer.heroku_run("APP=#{ENV['HEROKU_APP_NAME']} \
                                     USER_EMAIL=#{@user_email} \
                                     DATABASE=DATABASE_URL \
                                     S3_BUCKET_PATH=#{bucket_backups_full_path} \
                                     /app/bin/backup.sh -ag5-backups-manager",
           {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''}
    )
  end

  def restore(save_id)
    GithubHerokuDeployer.heroku_run(
      "APP=#{ENV['HEROKU_APP_NAME']} DATABASE=DATABASE_URL BACKUP_NAME=#{save_id} BACKUP_URL='#{get_dump_presigned_url(save_id)}' /app/bin/restore.sh -ag5-backups-manager", {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''})
  end

  private

  def bucket_target_branch
    s3_bucket.as_tree(prefix: backups_path).children
  end

  def backups_path
    "/#{client.bucket_asset_key_prefix}/#{FOLDER_NAME}"
  end

  def bucket_backups_full_path
    "#{s3_bucket.name}/#{client.bucket_asset_key_prefix}/#{FOLDER_NAME}"
  end

  def client
    Client.take
  end

  def client_urn
    client.urn
  end

  def bucket_name
    S3BucketNameManager.new(client).bucket_name
  end

  def s3_bucket
    AWS.s3.buckets[bucket_name]
  end

  def get_dump_presigned_url(save_id)
    s3_bucket.objects["#{save_id}.dump"].url_for(:get, :expires => 10*60).to_s
  end

end

