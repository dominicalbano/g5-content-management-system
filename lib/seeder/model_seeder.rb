module Seeder
  class ModelSeeder
    attr_reader :instructions

    protected

    def template_params
      ActionController::Parameters.new(@instructions).permit(:name, :title)
    end

    def params_for(model, instructions, parameter)
      component = model.find_by_slug(instructions["slug"])
      instructions = instructions.dup
      instructions[parameter.to_s] = component.try(:id)
      ActionController::Parameters.new(instructions).permit(parameter)
    end
  end
end