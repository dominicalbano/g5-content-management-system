class SocialFeedWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    [
      'blog_feed_url',
      'blog_feed_display_summary',
      'blog_feed_number_to_display',
      'twitter_username',
      'display_avatars',
      'twitter_tweet_count',
      'facebook_post_count',
      'facebook_page_id',
      'google_plus_post_count',
      'google_plus_page_id'
    ]
  end
end
