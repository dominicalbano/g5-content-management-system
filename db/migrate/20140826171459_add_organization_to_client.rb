class AddOrganizationToClient < ActiveRecord::Migration
  def change
    add_column :clients, :organization, :string
  end
end
