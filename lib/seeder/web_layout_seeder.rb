module Seeder
  class WebLayoutSeeder < Seeder::GardenSeeder
    protected

    def garden_class
      GardenWebLayout
    end

    def garden_id
      :garden_web_layout_id
    end

    def create_garden_method
      :create_web_layout
    end
  end
end