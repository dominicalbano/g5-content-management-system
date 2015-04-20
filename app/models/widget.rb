class Widget < ActiveRecord::Base
  include RankedModel
  include HasManySettings
  include UpdateNavSettings
  include LiquidParameters

  validates :garden_widget_id, presence: true

  ranks :display_order, with_same: :drop_target_id, scope: :has_drop_target

  belongs_to :garden_widget
  belongs_to :drop_target
  has_one :web_template, through: :drop_target
  has_many :widget_entries, dependent: :destroy

  # prefix means access with `garden_widget_settings` not `settings`
  delegate :settings, to: :garden_widget, allow_nil: true, prefix: true
  delegate :name, :slug, :url, :thumbnail, :liquid, :edit_html, :edit_javascript, :show_html, :widget_type, to: :garden_widget, allow_nil: true
  delegate :website_id, to: :web_template, allow_nil: true
  delegate :html_id, to: :drop_target, allow_nil: true
  delegate :client, to: :drop_target, allow_nil: true

  after_initialize :set_defaults
  after_create :update_settings!

  scope :has_drop_target, -> { where("drop_target_id IS NOT NULL") }
  scope :by_name, ->(name) { joins(:garden_widget).where("garden_widgets.name = ?", name) }
  scope :by_slug, ->(slug) { joins(:garden_widget).where("garden_widgets.slug = ?", slug) }
  scope :name_like_form, -> { joins(:garden_widget).where("garden_widgets.name LIKE '%Form'") }
  scope :meta_description, -> { joins(:garden_widget).where("garden_widgets.name = ?", "Meta Description") }
  scope :not_meta_description, -> { joins(:garden_widget).where("garden_widgets.name != ?", "Meta Description") }

  def show_stylesheets
    lib_array(:show_stylesheets)
  end

  def show_javascripts
    lib_array(:show_javascript)
  end

  def lib_javascripts
    lib_array(:lib_javascripts)
  end

  def lib_array(param)
    [garden_widget.try(param), widgets.collect { |w| w.try(param) }].flatten.compact.uniq
  end

  def get_setting(name)
    settings.detect { |s| s.name == name }
  end

  def get_setting_value(name)
    get_setting(name).try(:value)
  end

  def set_setting(name, value)
    setting = get_setting(name)
    setting.update_attribute(:value, value) if setting
  end

  def widgets
    [] # non-layout widgets don't have child widgets
  end

  def kind_of_widget?(kind)
    name == kind || slug == kind
  end

  def is_layout?
    false
  end

  def render_show_html(preview=false)
    html = liquid_render(show_html, "widget" => liquid_widget_drop(preview))
    html = liquid_render(html, liquid_parameters) if liquid
    html
  end

  def render_edit_html
    liquid_render(edit_html, "widget" => liquid_widget_drop)
  end

  def create_widget_entry_if_updated
    widget_entries.create if updated_since_last_widget_entry
  end

  def updated_since_last_widget_entry
    return true if widget_entries.blank?
    updated_at > widget_entries.maximum(:updated_at)
  end

  def update_settings!
    return unless garden_widget_settings
    updated_settings = garden_widget_settings.inject([]) do |arr, gw_setting|
      arr << update_setting(gw_setting)
    end
    (settings - updated_settings).map(&:destroy)
  end

  def update_setting(widget_settings)
    setting = settings.find_or_initialize_by(name: widget_settings[:name])
    setting.update_attributes({editable: widget_settings[:editable], default_value: widget_settings[:default_value], categories: widget_settings[:categories]})
    setting
  end

  def get_web_template(object=self)
    (object.web_template || get_web_template(object.parent_widget)) if object
  end

  def parent_widget
    setting = parent_setting
    Widget.find_by_id(setting.owner_id) if setting
  end

  def parent_content_stripe(object=self)
    w = object.parent_widget
    return w if (w && w.kind_of_widget?('content-stripe'))
    parent_content_stripe(w) if w
  end

  def liquid_render(html, params)
    Liquid::Template.parse(html).render(params)
  end

  def liquid_widget_drop(preview=false)
    WidgetDrop.new(self, client.try(:locations), preview)
  end

  def nested_settings
    widgets.collect {|widget| widget.settings}.flatten
  end

  private

  def set_defaults
    self.removeable = true
    extend_widget
  end

  def extend_widget
    begin
      mod = "Widgets::#{name.gsub(' ','').classify}Widget".constantize
      extend mod if mod.is_a?(Module)
    rescue => e
      # do nothing - this is normal
    end
  end

  def widget_settings
    settings.select { |setting| setting.name =~ /(?=.*widget_id\z).*/ && setting.value != nil }
  end

  def parent_setting
    Setting.where("value = ?", id.to_yaml).find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/
    end unless drop_target
  end
end
