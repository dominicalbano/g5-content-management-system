class GardenWebTheme < ActiveRecord::Base
  include ComponentGardenable

  set_garden_url ENV["THEME_GARDEN_URL"]

  serialize :stylesheets, Array
  serialize :javascripts, Array
  serialize :layouts, Array

  has_many :web_themes, dependent: :destroy

  after_initialize :set_defaults

  validates :name, presence: true
  validates :slug, presence: true
  validates :url, presence: true
  validates :thumbnail, presence: true

  def in_use?
    web_themes.present?
  end

  private

  def set_defaults
    self.stylesheets ||= []
    self.javascripts ||= []
    self.layouts ||= []
  end
end
