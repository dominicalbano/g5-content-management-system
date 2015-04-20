
module Seeder
  class GardenSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :template, :website

    def initialize(template, instructions)
      @template = template
      @instructions = instructions
    end

    def seed
      raise SyntaxError unless has_valid_instructions?
      @template.send(create_garden_method, garden_params)
      @template
    end
    
    protected

    def has_valid_instructions?
      @template && @instructions &&
      @instructions.has_key?(:slug)
    end

    def garden_params
      params_for(garden_class, @instructions, garden_id)
    end

    def garden_class
      raise NotImplementedError
    end

    def garden_id
      raise NotImplementedError
    end

    def create_garden_method
      raise NotImplementedError
    end
  end
end