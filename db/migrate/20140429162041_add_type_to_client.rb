class AddTypeToClient < ActiveRecord::Migration
  def change
    add_column :clients, :type, :string
  end
end
