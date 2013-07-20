module DefaultWebPageTemplates
  extend ActiveSupport::Concern

  DEFAULT_WEB_PAGE_TEMPLATES = [
    "Amenities",
    "Floorplans and Rates",
    "Map And Directions",
    "Neighborhood",
    "Photo Gallery",
    "Residents",
    "Coupon"
  ].freeze
  
  DISABLED_DEFAULT_WEB_PAGE_TEMPLATES = [
    "Coupon"
  ].freeze

  included do
    after_create :configure_default_web_page_templates 
  end
  
  def disabled_default_web_page_templates
    DISABLED_DEFAULT_WEB_PAGE_TEMPLATES
  end

  def default_web_page_templates
    DEFAULT_WEB_PAGE_TEMPLATES 
  end

  private

  def configure_default_web_page_templates
    default_web_page_templates.each do |template|
      mod = determine_module(template)
      web_page_templates << WebPageTemplate.new(name: template, disabled: disabled_template?(template)).extend(mod)
    end
  end

  def disabled_template?(template)
    disabled_default_web_page_templates.include?(template)
  end

  def determine_module(template)
    begin
      "#{template} Template".titleize.gsub(/\s+/, '').constantize
    rescue NameError
      Module.new
    end
  end
end