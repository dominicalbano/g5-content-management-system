module Seeder
  class ModelSeeder
    protected

    def params_for(model, instructions, parameter)
      component = model.find_by_slug(instructions[:slug])
      instructions = instructions.dup
      instructions[parameter.to_s] = component.try(:id)
      ActionController::Parameters.new(instructions).permit(parameter)
    end
  end
end