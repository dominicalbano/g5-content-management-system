class GardenWidget < ActiveRecord::Base
  include ComponentGardenable

  set_garden_url ENV["WIDGET_GARDEN_URL"]

  serialize :lib_javascripts, Array
  serialize :show_stylesheets, Array
  serialize :settings, Array

  has_many :widgets, autosave: true, dependent: :destroy

  validates :name, presence: true
  validates :widget_id, presence: true
  validates :slug, presence: true
  validates :url, presence: true
  validates :liquid, presence: true
  validates :widget_modified, presence: true
  validates :thumbnail, presence: true
  validates :edit_html, presence: true
  validates :show_html, presence: true

  def update_widgets_settings!
    widgets.map(&:update_settings!)
  end
end
