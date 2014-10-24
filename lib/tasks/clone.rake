namespace :clone do
  desc "Clones all layout, theme, templates and widgets from one location to another"

  task :location, [:source_location_id, :target_location_id] => :environment do |t, args|
    Cloner::LocationCloner.new(args.source_location_id, args.target_location_id).clone
  end
end
