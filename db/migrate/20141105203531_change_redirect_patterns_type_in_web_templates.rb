class ChangeRedirectPatternsTypeInWebTemplates < ActiveRecord::Migration
  def change
    change_column :web_templates, :redirect_patterns, :text
  end
end
