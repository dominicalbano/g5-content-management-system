module Seeder
  class DropTargetSeeder
    attr_reader :instructions, :website, :template

    def initialize(template, instructions)
      @instructions = instructions
      @template = template
    end

    def seed
      raise SyntaxError unless @template && @instructions
      Rails.logger.debug("Creating drop targets from instructions")
      @drop_targets = @instructions.inject([]) do |targets, instruction|
        drop_target = @template.drop_targets.create(drop_target_params(instruction))
        targets << create_widgets(drop_target, instruction[:widgets])
        targets
      end
    end

    def create_widgets(drop_target, instructions)
      Rails.logger.debug("Creating widgets from instructions")
      if drop_target && instructions
        instructions.each do |instruction|
          WidgetSeeder.new(drop_target, instruction).seed
        end
      end
      drop_target
    end

    private

    def drop_target_params(instructions)
      ActionController::Parameters.new(instructions).permit(:html_id)
    end
  end
end