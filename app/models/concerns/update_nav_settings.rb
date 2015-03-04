module UpdateNavSettings
  NAVIGATION_WIDGETS = ["Navigation", "Calls To Action"]
  LAYOUT_WIDGETS = ["Content Stripe", "Column"]

  extend ActiveSupport::Concern

  included do
    after_create :update_nav_settings, if: :navigation_widget?
    after_update :update_nav_settings, if: :layout_widget?
  end

  private

  def navigation_widget?
    NAVIGATION_WIDGETS.include?(garden_widget.name)
  end

  def layout_widget?
    LAYOUT_WIDGETS.include?(garden_widget.name)
  end

  def update_nav_settings
    Resque.enqueue(UpdateNavigationSettingsJob, website.id) if website
  end

  def website
    WebsiteFinder::Widget.new(self).find
  end
end
