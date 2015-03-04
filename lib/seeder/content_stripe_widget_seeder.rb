module Seeder
  class ContentStripeWidgetSeeder < Seeder::LayoutWidgetSeeder
    protected

     def layout_var
      "row_layout"
    end

    def position_var
      "column"
    end
  end
end