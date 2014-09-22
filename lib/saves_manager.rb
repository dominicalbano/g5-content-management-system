class SavesManager
  DEFAULT_LIMIT = 5

  def initialize(limit=nil)
    @limit = limit || DEFAULT_LIMIT
  end

  def fetch_all
    s3 = AWS.s3.buckets['g5-heroku-pgbackups-archive']
    items = JSON.parse(HerokuClient.new(location.website.urn).saves)

    process(filtered(items)).first(@limit)
  rescue
    []
  end

  def rollback(save_id)
    HerokuClient.new(location.website.urn).rollback(save_id)
  end

  private


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
