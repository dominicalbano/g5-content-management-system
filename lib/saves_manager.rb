class SavesManager
  FOLDER_NAME = "db-backups"

  def initialize(user_email)
    @user_email = user_email.parameterize
  end


  def fetch_all
    items = bucket_target_branch_children.select do |leaf|
      leaf.key if leaf.key =~ /.+\.dump\z/
    end.map do |leaf|
      { id: leaf.key.split('/').last.rpartition('.').first,
        created_at: leaf.object.last_modified }
    end.sort {|a,b| b[:created_at] <=> a[:created_at]}
  rescue => e
    Rails.logger.warn e.message
    []
  end

  def save
    begin
      GithubHerokuDeployer.heroku_run("APP=#{ENV['HEROKU_APP_NAME']} \
                                       USER_EMAIL=#{@user_email} \
                                       DATABASE=DATABASE_URL \
                                       S3_BUCKET_PATH=#{bucket_backups_full_path} \
                                       /app/bin/backup.sh -ag5-backups-manager",
             {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''}
      )
      return "Saving. This may take a few minutes."
    rescue => e
      return e
    end
  end

  def restore(save_id)
    GithubHerokuDeployer.heroku_run(
      "APP=#{ENV['HEROKU_APP_NAME']} DATABASE=DATABASE_URL BACKUP_NAME=#{save_id} BACKUP_URL='#{get_dump_presigned_url(save_id)}' /app/bin/restore.sh -ag5-backups-manager", {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''})
  end

  private

  def bucket_target_branch_children
    s3_bucket.as_tree(prefix: backups_path).children
  end

  def backups_path
    "#{prefix}/#{FOLDER_NAME}"
  end

  def bucket_backups_full_path
    "#{s3_bucket.name}/#{backups_path}"
  end

  def prefix
    client.bucket_asset_key_prefix
    #"mj-c-6h0so0g-cloud-storage"
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
    bucket_target_branch_children.select do |object| 
      object.key == "#{backups_path}/#{save_id}.dump"
    end.first.url_for(:get, :expires => 10*60).to_s
  end

end

