class WebTemplateDestroyerJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :destroyer

  def self.perform(web_template_id)
    WebTemplateDestroyer.new(web_template_id).destroy
  end
end
