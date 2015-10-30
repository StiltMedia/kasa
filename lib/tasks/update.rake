include CustomRets
namespace :update do
  namespace :rets do
    desc "Update RETS properties"
    task :properties => :environment do
      rets_query.each do |query|
        puts query
        begin
          client = make_rets_connection
          properties = client.find :all, {
            class:          '1',
            query:          query,
            resolve:        true,
            search_type:    'Property',
            standard_name:  1
          }
        rescue => e
          puts 'Error: ' + e.message
          client.logout
          exit!
        end
        properties.each do |property|
          UpdateRetsPropertiesWorker.perform_async(property['ListingID'])
        end
        client.logout
      end
    end
  end
end
