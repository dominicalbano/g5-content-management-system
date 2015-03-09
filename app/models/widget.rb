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

  def widgets
    more_widgets = child_widgets.collect { |widget| widget.try(:widgets) }

    [child_widgets, more_widgets].flatten.compact
  end

  def kind_of_widget?(kind)
    name == kind
  end

  def is_content_stripe?
    kind_of_widget?("Content Stripe")
  end

  def is_column?
    kind_of_widget?("Column")
  end

  def render_show_html
    return RowWidgetShowHtml.new(self).render if is_content_stripe?
    return ColumnWidgetShowHtml.new(self).render if is_column?
    html = Liquid::Template.parse(show_html).render(
      "widget" => WidgetDrop.new(self, client.try(:locations)))
    html = Liquid::Template.parse(html).render(liquid_parameters) if liquid
    html
  end

  def render_edit_html
    Liquid::Template.parse(edit_html).render(
      "widget" => WidgetDrop.new(self, client.try(:locations)))
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
    template = get_web_template
    client = template.client
    location = template.owner
    {
      "web_template_name"         => template.name,
      "client_name"               => client.name,
      "client_vertical"           => client.vertical,
      "location_name"             => location.name,
      "location_city"             => location.city,
      "location_state"            => location.state,
      "location_neighborhood"     => location.neighborhood,
      "location_floor_plans"      => location.floor_plans,
      "location_primary_amenity"  => location.primary_amenity,
      "location_qualifier"        => location.qualifier,
      "location_primary_landmark" => location.primary_landmark
    }
  end

  private

  def get_web_template(widget=self)
    widget.web_template || get_web_template(widget.parent_widget)
  end

  # TODO: Is this being used?
  def set_defaults
    self.removeable = true
  end

  def widget_settings
    pattern = /(?=.*widget_id\z).*/
    settings.select { |setting| setting.name =~ pattern && setting.value != nil }
  end

  def child_widgets
    widget_settings.map(&:value).map { |id| Widget.find(id) if Widget.exists?(id) }.compact
  end

  def has_child_widget?(widget)
    widget_settings.map(&:value).include?(widget.id)
  end

  def parent_widget
    return nil if drop_target
    parent_setting = Setting.where("value = ?", id.to_yaml).find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/
    end
    Widget.find(parent_setting.owner_id) if parent_setting
  end
end
