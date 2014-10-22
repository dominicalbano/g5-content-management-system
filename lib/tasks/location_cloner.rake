namespace :location_cloner do
  desc "Clones all the things from one location to another"

  task :clone, [:source_location_id, :target_location_id] => :environment do |t, args|
    LocationCloner.new(args.source_location_id, args.target_location_id).clone
  end
end
