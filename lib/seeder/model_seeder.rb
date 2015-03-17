module Seeder
  class ModelSeeder

    def load_yaml_file(filename)
      unless filename.blank? || yaml_file_path.blank?
        filename = "#{filename}.yml" unless filename.include?('.yml')
        filepath = "#{yaml_file_path}/#{filename}"
        @instructions = HashWithIndifferentAccess.new(YAML.load_file(filepath)) if File.exists?(filepath)
      end
    end
    
    protected

    def load_instructions(instructions)
      return load_yaml_file(instructions) unless instructions.is_a?(Hash)
      @instructions = instructions
    end

    def params_for(model, instructions, parameter)
      component = model.find_by_slug(instructions[:slug])
      instructions = instructions.dup
      instructions[parameter.to_s] = component.try(:id)
      ActionController::Parameters.new(instructions).permit(parameter)
    end

    def yaml_file_path
      "" # abstract
    end

    def seed
      nil # abstract
    end
  end
end