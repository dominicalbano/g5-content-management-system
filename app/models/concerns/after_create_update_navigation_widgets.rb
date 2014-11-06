module AfterCreateUpdateNavigationWidgets
  NAVIGATION_WIDGETS = ["Navigation", "Calls To Action"]

  extend ActiveSupport::Concern

  included do
    after_create :update_nav_settings, if: :should_update?
  end

  private

  def should_update?
    NAVIGATION_WIDGETS.include?(garden_widget.name)
  end

  def update_nav_settings
    Resque.enqueue(UpdateNavigationSettingsJob, website.id) if website
  end

  def website
    WebsiteFinder::Widget.new(self).find
  end
end
