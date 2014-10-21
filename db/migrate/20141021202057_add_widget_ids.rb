class AddWidgetIds < ActiveRecord::Migration
  def change
    widget_list = [
      [1, "analytics"],
      [2, "apply-form"],
      [3, "brochure-form"],
      [4, "button"],
      [5, "calls-to-action"],
      [6, "column"],
      [7, "comarketing"],
      [8, "contact-form"],
      [9, "contact-info"],
      [10, "contact-info-sheet"],
      [11, "row"],
      [12, "corporate-locations-map"],
      [13, "coupon"],
      [14, "directions"],
      [15, "featured-properties"],
      [16, "floorplans"],
      [17, "floorplans-cards"],
      [18, "footer-info"],
      [19, "gallery"],
      [20, "hold-unit-form"],
      [21, "home-multifamily-iui"],
      [22, "html"],
      [23, "lead-form"],
      [24, "locations-navigation"],
      [25, "logo"],
      [26, "map"],
      [27, "meta"],
      [28, "meta-description"],
      [29, "multifamily-iui-cards"],
      [30, "multifamily-mini-search"],
      [31, "multifamily-search"],
      [32, "navigation"],
      [33, "phone-number"],
      [34, "photo"],
      [35, "photo-group"],
      [36, "quote"],
      [37, "request-info-form"],
      [38, "review-form"],
      [39, "self-storage-iui-filtered"],
      [40, "service-request-form"],
      [41, "social-feed"],
      [42, "social-links"],
      [43, "suggestion-form"],
      [44, "tell-a-friend"],
      [45, "tour-form"],
      [46, "typekit"],
      [47, "video"]
    ]

    widget_list.each do |value|
      garden_widget = GardenWidget.find_by_slug(value[1])
      garden_widget.update(widget_id: value[0]) if garden_widget
    end
  end
end
