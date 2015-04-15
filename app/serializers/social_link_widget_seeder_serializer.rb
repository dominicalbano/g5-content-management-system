class SocialLinkWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  ## TODO: Need to add a few more once we get the models updated in HUB and CMS

  def extended_settings_list
    [
      'twitter_username',
      'facebook_username',
      'yelp_username',
      'google_plus_id',
      'pinterest_username',
      'instagram_username',
      'youtube_username'
    ]
  end
end
