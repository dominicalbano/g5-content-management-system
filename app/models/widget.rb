class Widget < ActiveRecord::Base
  include AssociationToMethod

  WIDGET_GARDEN_URL = "http://0.0.0.0:3001"

  attr_accessible :page_id, :section, :position, :url, :name, :stylesheets,
                  :javascripts, :html, :thumbnail, :edit_form_html,
                  :widget_attributes_attributes

  serialize :stylesheets, Array
  serialize :javascripts, Array

  belongs_to :page
  has_many :settings, as: :component, after_add: :define_dynamic_association_method
  has_many :widget_attributes, through: :settings

  accepts_nested_attributes_for :widget_attributes

  alias_attribute :dynamic_association, :settings

  before_create :assign_attributes_from_url

  validates :url, presence: true

  scope :in_section, lambda { |section| where(section: section) }

  def self.all_remote
    components = G5HentryConsumer::HG5Component.parse(WIDGET_GARDEN_URL)
    components.map do |component|
      new(url: component.uid, name: component.name.first, thumbnail: component.thumbnail.first)
    end
  end

  def liquidized_html
    Liquid::Template.parse(CGI::unescape(self.html)).render("widget" => self)
  end

  def kind_of_widget?(kind)
    name == kind
  end

  private

  def assign_attributes_from_url
    component = G5HentryConsumer::HG5Component.parse(url).first
    if component
      self.name           = component.name.first
      self.stylesheets    = component.stylesheets
      self.javascripts    = component.javascripts
      self.edit_form_html = get_edit_form_html(component)
      self.html           = get_show_form_html(component)
      self.thumbnail      = component.thumbnail.first
      parse_settings(component.configurations)
      true
    else
      raise "No h-g5-component found at url: #{url}"
    end
  rescue OpenURI::HTTPError => e
    logger.warn e.message
  end

  def parse_settings(configs)
    return if configs.blank?
    configs.each do |config|
      setting = self.settings.build(name: config.name, categories: config.category)
      config.attributes.each do |attribute|
        setting.widget_attributes.build(name: attribute.name, editable: attribute.editable || false, default_value: attribute.default_value)
      end
    end
  end

  def get_edit_form_html(component)
    url = component.edit_template.try(:first)
    open(url).read if url
  end

  def get_show_form_html(component)
    url = component.show_template.try(:first)
    open(url).read if url
  end

end
