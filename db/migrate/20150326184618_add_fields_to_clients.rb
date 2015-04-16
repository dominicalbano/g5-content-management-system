class AddFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :go_squared_client_id, :string
    add_column :clients, :go_squared_tag, :string
  end
end
