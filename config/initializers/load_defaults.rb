WEBSITE_DEFAULTS_PATH = "#{Rails.root}/config/defaults/websites"
WEB_PAGE_DEFAULTS_PATH = "#{Rails.root}/config/defaults/pages"
CONTENT_STRIPE_DEFAULTS_PATH = "#{Rails.root}/config/defaults/content_stripes"

WEBSITE_DEFAULTS = HashWithIndifferentAccess.new(YAML.load_file("#{WEBSITE_DEFAULTS_PATH}/defaults.yml"))
WEBSITE_DEFAULTS_APARTMENTS = HashWithIndifferentAccess.new(YAML.load_file("#{WEBSITE_DEFAULTS_PATH}/website_defaults_apartments.yml"))
WEBSITE_DEFAULTS_SENIOR_LIVING = HashWithIndifferentAccess.new(YAML.load_file("#{WEBSITE_DEFAULTS_PATH}/website_defaults_senior_living.yml"))
WEBSITE_DEFAULTS_SELF_STORAGE = HashWithIndifferentAccess.new(YAML.load_file("#{WEBSITE_DEFAULTS_PATH}/website_defaults_self_storage.yml"))

##TODO: delete this when done testing
CHATHAM_WOOD_APTS = HashWithIndifferentAccess.new(YAML.load_file("#{WEBSITE_DEFAULTS_PATH}/g5-cl-1sv8k4zu-chatham-wood-apartments.yml"))
