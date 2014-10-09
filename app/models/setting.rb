require_dependency "hash_with_to_liquid"

class Setting < ActiveRecord::Base
  include SettingNavigation
  include SettingLayoutWidgetGardenWidgets

  PRIORITIZED_OWNERS = [
    "Widget",
    "WebTemplate",
    "WebPageTemplate",
    "WebHomeTemplate",
    "WebsiteTemplate",
    "WebLayout",
    "WebTheme",
    "Website",
    "Location",
    "Client"
  ]

  serialize :value
  serialize :categories, Array

  belongs_to :owner, polymorphic: true
  belongs_to :website

  before_create :set_priority
  after_create :set_website_id

  validates :name, presence: true
  validates :owner, presence: true
  validates :owner_type, presence: true, inclusion: { in: PRIORITIZED_OWNERS }
  validates :priority, presence: true, numericality: { only_integer: true },
    unless: :new_record?

  scope :where_name, ->(name) { where(name: name) }
  scope :value_is_present, -> { where("value IS NOT NULL") }
  scope :order_priority_asc, -> { order("priority ASC") }
  scope :order_priority_desc, -> { order("priority DESC") }
  scope :where_priority_gte, ->(priority) { where("priority >= ?", priority) }
  scope :where_priority_gt, ->(priority) { where("priority > ?", priority) }
  scope :where_priority_lt, ->(priority) { where("priority < ?", priority) }
  scope :for_website, ->(wid) { where(website_id: wid) }
  scope :for_no_website, -> { where("website_id IS NULL") }

  # TODO: rename to best_value to value
  # TODO: rename value to my_value or something
  def best_value
    value || others_with_lower_priority.first.try(:value) || global_others.first.try(:value) || default_value
  end

  def global_others
    query = self.class
    query = query.for_no_website
    query = query.where_name(name)
    query = query.value_is_present
    query = query.order_priority_asc
  end

  def others_with_higher_priority
    query = others.order_priority_desc
    query = query.where_priority_lt(priority)
  end

  def others_with_lower_priority
    query = others.order_priority_asc
    query = query.where_priority_gte(priority)
  end

  private

  def others
    if website_id.nil? then set_website_id end
    query = self.class
    query = query.for_website(website_id) if website_id
    query = query.where_name(name)
    query = query.value_is_present
  end

  def set_website_id
    self.website ||= SettingWebsiteFinder.new(self).find
    save
  end

  def set_priority
    self.priority ||= PRIORITIZED_OWNERS.index(owner_type)
  end
end
