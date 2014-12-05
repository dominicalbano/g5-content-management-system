class ClientDeployerJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :static_website_deployer

  def self.perform(user_email)
    new(user_email).perform
  end

  def initialize(user_email)
    @user_email = user_email
  end

  def perform
    ClientDeployer.compile_and_deploy(Client.first, @user_email)
  end
end
