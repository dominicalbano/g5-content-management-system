class PromotedReviewWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    [
      'branded_name',
      'review_page_url'
    ]
  end
end
