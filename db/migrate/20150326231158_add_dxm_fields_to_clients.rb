class AddDxmFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :cls_url, :string
    add_column :clients, :cxm_url, :string
    add_column :clients, :dsh_url, :string
    add_column :clients, :cpas_url, :string
    add_column :clients, :cpns_url, :string
    add_column :clients, :nae_url, :string
    add_column :clients, :vls_url, :string

    ClientReader.new(ENV["G5_CLIENT_UID"]).perform
  end
end
