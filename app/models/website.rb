class Website < ActiveRecord::Base
  include HasManySettings
  include HasSettingNavigation
  include HasSettingLocationsNavigation
  include HasSettingCorporateMap
  include AfterCreateUpdateUrn
  include ToParamUrn

  COMPILE_PATH = File.join(Rails.root, "tmp","static_sites")

  set_urn_prefix "g5-clw"

  belongs_to :owner, polymorphic: true

  has_one  :website_template, dependent: :destroy
  has_one  :web_home_template, dependent: :destroy
  has_many :web_page_templates, -> { order("web_templates.display_order ASC") }, dependent: :destroy
  has_many :web_templates
  has_many :assets, dependent: :destroy
  has_many :widgets, through: :web_templates
  has_many :categories, through: :assets

  validates :urn, presence: true, uniqueness: true, unless: :new_record?

  scope :location_websites, -> { where(owner_type: "Location") }

  def widget_settings
    widgets.collect {|widget| widget.settings}.flatten +
    widgets.collect {|widget| widget.nested_settings}.flatten
  end

  def website_id
    id
  end

  def name
    owner.try(:name)
  end

  def slug
    name.try(:parameterize)
  end

  def compile_path
    if single_domain_location?
      return File.join(COMPILE_PATH, client.website.urn) if corporate?
      File.join(COMPILE_PATH, client.website.urn, single_domain_location_path)
    else
      File.join(COMPILE_PATH, urn)
    end
  end

  def stylesheets
    [web_home_template.try(:stylesheets),
    web_page_templates.map(&:stylesheets),
    website_template.try(:stylesheets)].flatten.uniq
  end

  def deploy(user_email)
    StaticWebsiteDeployerJob.perform(urn, user_email)
  end

  def async_deploy(user_email)
    Resque.enqueue(StaticWebsiteDeployerJob, urn, user_email)
  end

  def colors
    website_template.try(:colors)
  end

  def fonts
    website_template.try(:fonts)
  end

  def stylesheets_compiler
    @stylesheets_compiler ||=
      StaticWebsite::Compiler::Stylesheets.new(stylesheets,
      "#{Rails.root}/public", colors, fonts, name)
  end

  def application_min_css_path
    if single_domain_location? && !corporate?
      "/#{single_domain_location_path}/stylesheets/application.min.css"
    else
      stylesheets_compiler.uploaded_path
    end
  end

  def single_domain_location_path
    "#{single_domain_location_base_path}/#{slug}"
  end

  def single_domain_location_base_path
    "#{client.vertical_slug}/#{owner.state_slug}/#{owner.city_slug}"
  end

  def corporate?
    owner_type == "Location" && owner.corporate?
  end

  def single_domain_location?
    client.type == "SingleDomainClient" && owner_type == "Location"
  end

  def client
    @client ||= Client.first
  end
end

