class UpdateClientHubData < ActiveRecord::Migration
  def change
    ClientReader.new(ENV["G5_CLIENT_UID"]).perform
  end
end
