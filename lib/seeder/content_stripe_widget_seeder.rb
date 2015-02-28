module Seeder
  class ContentStripeWidgetSeeder < Seeder::LayoutSeeder
    protected

     def layout_var
      "row_layout"
    end

    def position_var
      "column"
    end
  end
end