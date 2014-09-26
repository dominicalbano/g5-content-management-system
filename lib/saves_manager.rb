class SavesManager
  DEFAULT_LIMIT = 5

  def initialize(user_email, limit=nil)
    @limit = limit || DEFAULT_LIMIT
    @user_email = user_email
  end

  def fetch_all
    bucket = AWS.s3.buckets["pgbackups.#{Client.first.urn}"]
    #V for testing
    #bucket = AWS.s3.buckets["pgbackups.g5-c-1skmeepf-clowns-monkeys-jokers"]

    items = bucket.objects.select do |object|
      object.key if object.key =~ /.+\.dump\z/
    end.map do |object|
      { id: object.key.split('.').first,
        created_at: object.last_modified,
        client: Client.first.id.to_s,
        url: object.key.split('/').last }
    end.sort {|a,b| b[:created_at] <=> a[:created_at]}
    #process(filtered(items)).first(@limit)
  rescue
    []
  end

  def save
    GithubHerokuDeployer.heroku_run("APP=#{ENV['HEROKU_APP_NAME']} DATABASE=DATABASE_URL S3_BUCKET_PATH=#{find_or_create_s3_bucket.name} /app/bin/backup.sh -ag5-backups-manager", {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''})
  end

  def restore(save_id)
    GithubHerokuDeployer.heroku_run(
      "APP=#{ENV['HEROKU_APP_NAME']} USER_EMAIL=#{@user_email} DATABASE=DATABASE_URL BACKUP_NAME=#{save_id} BACKUP_URL='#{get_dump_presigned_url(save_id)}' /app/bin/restore.sh -ag5-backups-manager", {github_repo:' ', heroku_app_name: "g5-backups-manager", heroku_repo: ''})
  end

  private

  def find_or_create_s3_bucket
    unless AWS.s3.buckets["pgbackups.#{Client.first.urn}"].exists?
      AWS.s3.buckets.create("pgbackups.#{Client.first.urn}")
    end
    AWS.s3.buckets["pgbackups.#{Client.first.urn}"]
  end

  def get_dump_presigned_url(save_id)
    find_or_create_s3_bucket.objects["#{save_id}.dump"].url_for(:get, :expires => 10*60).to_s
  end

  def filtered(items)
    items.select { |item| item if deploy?(item) || rollback?(item) }
  end

  def current_deploy(items)
    return items.first if deploy?(items.first)
    current = items.detect { |item| item["version"] == version(items.first) }

    current.present? ? current : items.detect { |item| deploy?(item) }
  end

  def process(items)
    flag_current(items).select { |item| item if deploy?(item) }
  end

  def flag_current(items)
    current = current_deploy(items.reverse!)
    items.each { |item| item["current"] = item == current ? true : false }
  end

  def deploy?(item)
    item["description"] =~ /Deploy/
  end

  def rollback?(item)
    item["description"] =~ /Rollback/
  end

  def version(item)
    item["description"].split("Rollback to v").last.to_i
  end
end

