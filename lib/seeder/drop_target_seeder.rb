module Seeder
  class DropTargetSeeder
    attr_reader :instructions, :website, :template

    def initialize(website, template, instructions)
      @instructions = instructions
      @website = website
      @template = template
    end

    def seed
      Rails.logger.debug("Creating drop targets from instructions")
      if @template && @instructions
        @instructions.each do |instruction|
          drop_target = @template.drop_targets.create(drop_target_params(instruction))
          create_widgets(drop_target, instruction["widgets"])
        end
      end
    end

    def create_widgets(drop_target, instructions)
      Rails.logger.debug("Creating widgets from instructions")
      if drop_target && instructions
        instructions.each do |instruction|
          WidgetSeeder.new(drop_target, instruction).seed
        end
      end
    end

    private

    def drop_target_params(instructions)
      ActionController::Parameters.new(instructions).permit(:html_id)
    end
  end
end