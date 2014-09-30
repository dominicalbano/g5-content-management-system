class SavesManager

  def initialize(user_email, limit=nil)
    @limit = limit || DEFAULT_LIMIT
    @user_email = user_email
  end


  def fetch_all
    bucket = AWS.s3.buckets[bucket_name]

    items = bucket.objects.select do |object|
      object.key if object.key =~ /.+\.dump\z/
    end.map do |object|
      { id: object.key.rpartition('.').first,
        created_at: object.last_modified }
    end.sort {|a,b| b[:created_at] <=> a[:created_at]}
  rescue
    []
  end

  def save
    GithubHerokuDeployer.heroku_run("APP=#{ENV['HEROKU_APP_NAME']} \
                                     USER_EMAIL=#{@user_email} \
                                     DATABASE=DATABASE_URL \
                                     S3_BUCKET_PATH=#{find_or_create_s3_bucket.name} \
                                     /app/bin/backup.sh -ag5-backups-manager",
           {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''}
    )
  end

  def restore(save_id)
    GithubHerokuDeployer.heroku_run(
      "APP=#{ENV['HEROKU_APP_NAME']} DATABASE=DATABASE_URL BACKUP_NAME=#{save_id} BACKUP_URL='#{get_dump_presigned_url(save_id)}' /app/bin/restore.sh -ag5-backups-manager", {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''})
  end

  private

  def bucket_name
    "assets.#{Client.first.urn}"
  end

  def find_or_create_s3_bucket
    unless AWS.s3.buckets[bucket_name].exists?
      AWS.s3.buckets.create(bucket_name)
    end
    AWS.s3.buckets[bucket_name]
  end

  def get_dump_presigned_url(save_id)
    find_or_create_s3_bucket.objects["#{save_id}.dump"].url_for(:get, :expires => 10*60).to_s
  end

end

