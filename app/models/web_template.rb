class WebTemplate < ActiveRecord::Base
  include RankedModel
  include HasManySettings
  include AfterUpdateSetSettingNavigation
  include LiquidParameters

  LOGGERS = [Rails.logger, Resque.logger]

  ranks :display_order, with_same: :website_id

  belongs_to :website
  has_one :website_template, through: :website
  has_one :website_layout, through: :website_template, source: :web_layout
  has_one :web_layout , autosave: true , dependent: :destroy
  has_one :web_theme  , autosave: true , dependent: :destroy
  has_many :drop_targets, autosave: true, dependent: :destroy
  has_many :widgets, -> { order("widgets.display_order ASC") }, through: :drop_targets

  delegate :application_min_css_path, :application_min_js_path,
    to: :website, allow_nil: true

  validates :title , presence: true
  validates :name  , presence: true
  validates :slug  , presence: true ,
    format: { with: /\A[-_A-Za-z0-9]*\z/, message: "can only contain letters, numbers, dashes, and underscores." }, unless: :new_record?

  scope :home, -> { where(name: "Home") }
  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
  scope :trash, -> { where(in_trash: true) }
  scope :not_trash, -> { where(in_trash: false) }
  scope :navigateable, -> { not_trash.enabled.where("type != ?", "WebsiteTemplate") }
  scope :created_at_asc, -> { order("created_at ASC") }
  scope :top_level, -> { where(parent_id: nil)}

  before_validation :default_enabled_to_true
  before_validation :default_in_trash_to_false
  before_validation :default_title_from_name
  before_validation :default_slug_from_title

  before_save :format_redirect_patterns

  # TODO: remove when Ember App implements DropTarget
  def main_widgets
    drop_targets.where(html_id: "drop-target-main").first.try(:widgets) || []
  end

  def meta_description_widgets
    widgets.meta_description
  end

  def owner
    @owner ||= website.try(:owner)
  end

  def client
    @client ||= Client.first
  end

  def single_domain?
    client.type == "SingleDomainClient"
  end

  def url
    client.url_formatter_class.new(self, owner).format
  end

  def web_home_template?
    type == "WebHomeTemplate"
  end

  def web_page_template?
    type == "WebPageTemplate"
  end

  def stylesheets
    widgets.map(&:show_stylesheets).flatten + website.try(:website_template).try(:stylesheets).to_a
  end

  def javascripts
    show_javascripts + lib_javascripts + website_template_javascripts
  end

  def stylesheets_compiler
    @stylesheets_compiler ||= StaticWebsite::Compiler::Stylesheets.new(stylesheets, "#{Rails.root}/public", website.try(:colors), website.try(:fonts), owner.try(:name), true)
  end

  def stylesheet_link_paths
    write_to_loggers("\n#### sending compile to stylesheets_compiler for web_template #{name}\n")
    stylesheets_compiler.compile
    write_to_loggers("\n#### sending link_paths to stylesheets_compiler for web_template #{name}\n")
    stylesheets_compiler.asset_urls
  end

  def preview_stylesheet_link_paths
    stylesheets
  end

  def javascripts_compiler
    @javascripts_compiler ||= StaticWebsite::Compiler::Javascripts.new(javascripts, "#{Rails.root}/public", name, owner.try(:name))
  end

  def javascript_include_paths
    write_to_loggers("Starting compile on javascripts_compiler for web_template: #{name}")
    javascripts_compiler.compile unless javascripts.empty?
    write_to_loggers("Finished compile on javascripts_compiler for web_template: #{name}")
    write_to_loggers("Calling upload_paths on javascripts_compiler for web_template:\n #{name}")
    javascripts_compiler.asset_urls
  end

  def owner_domain
    owner.domain if owner
  end

  def page_url
    if single_domain_internal_page?
      File.join(domain_for_type.to_s, website.single_domain_location_path.to_s, slug)
    else
      File.join(domain_for_type.to_s, relative_path.to_s)
    end
  end

  def last_mod
    return updated_at.to_date if widgets.empty?
    widgets.order("updated_at").last.updated_at.to_date
  end

  def render_title
    Liquid::Template.parse(title).render(liquid_parameters)
  end

  def base_path
    if single_domain? && website.corporate?
      client.website.compile_path
    else
      website.compile_path
    end
  end

  def body_class
    type.titleize.parameterize
  end

  def location_body_class
    website.corporate? ? "site-corporate" : "site-location"
  end

  def children
    WebTemplate.where(parent_id: id).order(:display_order)
  end

  def top_level?
    !child_template?
  end

  def child_template?
    parent_id.present?
  end

  private

  def show_javascripts
    widgets.map(&:show_javascripts).flatten.compact
  end

  def lib_javascripts
    widgets.map(&:lib_javascripts).flatten.compact
  end

  def website_template_javascripts
    website.try(:website_template).try(:javascripts).to_a.flatten.compact
  end

  def default_enabled_to_true
    # ||= does not work here because enabled is a boolean
    self.enabled = true if enabled.nil?
  end

  def default_in_trash_to_false
    # ||= does not work here because in_trash is a boolean
    self.in_trash = false if in_trash.nil?
    # return true to continue validation
    true
  end

  def default_title_from_name
    self.title ||= name
  end

  def default_slug_from_title
    self.slug ||= name.parameterize
  end

  def format_redirect_patterns
    self.redirect_patterns = redirect_patterns.split.uniq.join("\n") if redirect_patterns
  end

  def domain_for_type
    single_domain? ? client.domain : owner.domain
  end

  def single_domain_internal_page?
    web_page_template? && single_domain? && !website.corporate?
  end
end

