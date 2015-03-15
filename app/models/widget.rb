class Widget < ActiveRecord::Base
  include RankedModel
  include HasManySettings
  include UpdateNavSettings

  validates :garden_widget_id, presence: true

  ranks :display_order, with_same: :drop_target_id

  belongs_to :garden_widget
  belongs_to :drop_target
  has_one :web_template, through: :drop_target
  has_many :widget_entries, dependent: :destroy

  delegate :website_id,
    to: :web_template, allow_nil: true

  delegate :html_id,
    to: :drop_target, allow_nil: true

  delegate :name, :slug, :url, :thumbnail, :liquid, :edit_html, :edit_javascript, :show_html, :widget_type,
    to: :garden_widget, allow_nil: true

  # prefix means access with `garden_widget_settings` not `settings`
  delegate :settings,
    to: :garden_widget, allow_nil: true, prefix: true
  delegate :client, to: :drop_target, allow_nil: true

  after_initialize :set_defaults
  after_create :update_settings!

  scope :name_like_form, -> {
    joins(:garden_widget).where("garden_widgets.name LIKE '%Form'") }
  scope :meta_description, -> {
    joins(:garden_widget).where("garden_widgets.name = ?", "Meta Description") }
  scope :not_meta_description, -> {
    joins(:garden_widget).where("garden_widgets.name != ?", "Meta Description") }
  scope :content_stripe, -> {
    joins(:garden_widget).where("garden_widgets.name = ?", "Content Stripe") }
  scope :column, -> {
    joins(:garden_widget).where("garden_widgets.name = ?", "Column") }
  scope :layout, -> {
    joins(:garden_widget).where("garden_widgets.name = ? OR garden_widgets.name = ?", "Content Stripe", "Column") }

  
  def show_stylesheets
    [garden_widget.try(:show_stylesheets), 
     widgets.collect(&:show_stylesheets)].flatten.compact.uniq
  end

  def show_javascripts
    [garden_widget.try(:show_javascript),
     widgets.collect(&:show_javascripts)].flatten.compact.uniq
  end

  def lib_javascripts
    [garden_widget.try(:lib_javascripts), 
     widgets.collect(&:lib_javascripts)].flatten.compact.uniq
  end

  def get_setting(name)
    settings.try(:find_by_name, name)
  end

  def get_setting_value(name)
    setting = get_setting(name)
    setting.value if setting
  end

  def set_setting(name, value)
    setting = get_setting(name)
    setting.update_attribute(:value, value) if setting
  end

  ## TODO: this needs to be part of refactored CS/Col widget classes
  def set_child_widget(position, widget)
    return unless is_layout? && widget
    prefix = "#{position_var}_#{position_name(position)}_widget_"
    set_setting("#{prefix}name", widget.name)
    set_setting("#{prefix}id", widget.id)
  end

  def widgets
    more_widgets = child_widgets.collect { |widget| widget.try(:widgets) }
    [child_widgets, more_widgets].flatten.compact
  end

  def kind_of_widget?(kind)
    name == kind
  end

  def is_layout?
    is_content_stripe? || is_column?
  end

  def is_content_stripe?
    kind_of_widget?("Content Stripe")
  end

  def is_column?
    kind_of_widget?("Column")
  end

  def render_show_html
    # this is smelly - needs refactor
    return RowWidgetShowHtml.new(self).render if is_content_stripe?
    return ColumnWidgetShowHtml.new(self).render if is_column?
    html = liquid_render(show_html, "widget" => liquid_widget_drop)
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
    updated_settings = []
    garden_widget_settings.each do |garden_widget_setting|
      setting = settings.find_or_initialize_by(name: garden_widget_setting[:name])
      setting.editable = garden_widget_setting[:editable]
      setting.default_value = garden_widget_setting[:default_value]
      setting.categories = garden_widget_setting[:categories]
      setting.save
      updated_settings << setting
    end
    removed_settings = settings - updated_settings
    removed_settings.map(&:destroy)
  end

  def nested_settings
    widgets.collect {|widget| widget.settings}.flatten
  end

  def liquid_parameters
    return {} unless liquid
    template = get_web_template
    client = template.client
    location = template.owner
    {
      "web_template_name"         => template.name,
      "location_name"             => location.name,
      "location_city"             => location.city,
      "location_state"            => location.state,
      "location_neighborhood"     => location.neighborhood,
      "location_floor_plans"      => location.floor_plans,
      "location_primary_amenity"  => location.primary_amenity,
      "location_qualifier"        => location.qualifier,
      "location_primary_landmark" => location.primary_landmark,
      "client_name"               => client.name,
      "client_vertical"           => client.vertical
    }
  end

  def get_web_template(widget=self)
    widget.web_template || get_web_template(widget.parent_widget)
  end

  def parent_widget
    setting = parent_setting
    Widget.find(setting.owner_id) if setting
  end

  def child_widgets
    widget_settings.map(&:value).map { |id| Widget.find(id) if Widget.exists?(id) }.compact
  end

  def has_child_widget?(widget)
    widget_settings.map(&:value).include?(widget.id)
  end

  def position_var
    # smelly, needs to be refactored
    return "" unless is_layout?
    is_content_stripe? ? "column" : "row"
  end

  def layout_var
    # smelly, needs to be refactored
    return "" unless is_layout?
    is_content_stripe? ? "row_layout" : "row_count"
  end

  private

  def liquid_render(html, params)
    Liquid::Template.parse(html).render(params)
  end

  def liquid_widget_drop
    WidgetDrop.new(self, client.try(:locations))
  end

  # TODO: Is this being used?
  def set_defaults
    self.removeable = true
  end

  def widget_settings
    pattern = /(?=.*widget_id\z).*/
    settings.select { |setting| setting.name =~ pattern && setting.value != nil }
  end

  def parent_setting
    Setting.where("value = ?", id.to_yaml).find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/
    end unless drop_target
  end

  def position_name(index)
    # smelly, needs to be refactored
    positions = { 1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five', 6 => 'six' }
    positions[index]
  end
end
