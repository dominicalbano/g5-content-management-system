module Seeder
  class ColumnWidgetSeeder < Seeder::LayoutWidgetSeeder
    protected 

    def layout_var
      "row_count"
    end

    def position_var
      "row"
    end
  end
end