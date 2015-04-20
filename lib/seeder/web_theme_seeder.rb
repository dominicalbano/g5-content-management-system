
module Seeder
  class WebThemeSeeder < Seeder::GardenSeeder
    protected

    def garden_class
      GardenWebTheme
    end

    def garden_id
      :garden_web_theme_id
    end

    def create_garden_method
      :create_web_theme
    end
  end
end