class AddSecureDomainToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :secure_domain, :boolean, default: false
  end
end
