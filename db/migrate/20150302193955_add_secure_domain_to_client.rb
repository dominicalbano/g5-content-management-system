class AddSecureDomainToClient < ActiveRecord::Migration
  def change
    add_column :clients, :secure_domain, :boolean, default: false
  end
end
