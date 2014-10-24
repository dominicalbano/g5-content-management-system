class Cloner::LocationCloner
  def initialize(source_location_id, target_location_id)
    @source_location = Location.find(source_location_id)
    @target_location = Location.find(target_location_id)
  end

  def clone
    Rails.logger.info "Cloning #{@source_location.name} pages " \
                      "and widgets to #{@target_location.name}"

    delete_target_web_templates
    clone_source_web_templates
  end

  private

  def delete_target_web_templates
    @target_location.website.web_templates.each do |web_template|
      WebTemplateDestroyer.new(web_template.id).destroy
    end
  end

  def clone_source_web_templates
    @source_location.website.web_templates.each do |web_template|
      Cloner::WebTemplateCloner.new(web_template, @target_location).clone
    end
  end
end
