class Widget < ActiveRecord::Base
  include RankedModel
  include HasManySettings

  ranks :display_order, with_same: :drop_target_id

  belongs_to :garden_widget
  belongs_to :drop_target
  has_one :web_template, through: :drop_target
  has_many :widget_entries, dependent: :destroy

  delegate :website_id,
    to: :web_template, allow_nil: true

  delegate :html_id,
    to: :drop_target, allow_nil: true

  delegate :name, :url, :thumbnail, :edit_html, :edit_javascript, :show_html,
    :show_javascript, :lib_javascripts, :show_stylesheets,
    to: :garden_widget, allow_nil: true

  # prefix means access with `garden_widget_settings` not `settings`
  delegate :settings,
    to: :garden_widget, allow_nil: true, prefix: true
  delegate :client, to: :drop_target

  after_initialize :set_defaults
  after_create :update_settings!

  scope :name_like_form, -> {
    joins(:garden_widget).where("garden_widgets.name LIKE '%Form'") }
  scope :meta_description, -> {
    joins(:garden_widget).where("garden_widgets.name = ?", "Meta Description") }
  scope :not_meta_description, -> {
    joins(:garden_widget).where("garden_widgets.name != ?", "Meta Description") }

  def kind_of_widget?(kind)
    name == kind
  end

  def render_show_html
    if row_widget?
      RowWidgetShowHtml.new(self).render
    else
      Liquid::Template.parse(show_html).render("widget" => self)
    end
  end

  def row_widget?
    name == "Row"
  end

  def render_edit_html
    Liquid::Template.parse(edit_html).render("widget" => WidgetDrop.new(self, client.locations))
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

  private

  # TODO: Is this being used?
  def set_defaults
    self.removeable = true
  end
end
