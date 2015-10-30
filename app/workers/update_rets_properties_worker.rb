class UpdateRetsPropertiesWorker

  include Sidekiq::Worker
  include CustomRets

  sidekiq_options queue: 'rets', :retry => false, :backtrace => true

  def perform(listing_id)
    begin
      rets_query = '(246=|A,B,C,CS,PS,Q,T,W,X),(61=|BROWARD,DADE,GLADES,HENDRY,INDNRIV,MARTIN,OKEECHB,OTHER,PALMBCH,STLUCIE),(157=*' + listing_id + '*)'
      client = make_rets_connection
      property = client.find :first, {
        class:          '1',
        limit:          1,
        query:          rets_query,
        resolve:        true,
        search_type:    'Property',
        standard_name:  1
      }
      photos = client.objects '*', {
        resource: 'Property',
        object_type: 'Photo',
        resource_id: property['sysid']
      }
      prop                        = Property.find_or_initialize_by(mls_listing_number: property['ListingID'])
      prop[:city]                 = property['City']
      prop[:bedrooms]             = property['Bedrooms']
      prop[:current_list_price]   = property['ListPrice']
      prop[:full_bathrooms]       = property['BathsFull']
      prop[:half_bathrooms]       = property['BathsHalf']
      prop[:zip]                  = property['PostalCode']
      prop[:mls_name]             = property['ListAgentFirstName']
      prop[:listing_office]       = property['ListOfficeOfficeID']
      prop[:description]          = property['Remarks']
      ## Modifacations may be needed on properties model
      #prop[] = result[                    "Type"]
      #prop[] = result[                   "State"]
      #prop[] = result[               "CloseDate"]
      #prop[] = result[              "ClosePrice"]
      #prop[] = result[              "Directions"]
      #prop[] = result[              "LivingArea"]
      #prop[] = result[              "StreetName"]
      #prop[] = result[            "StreetNumber"]
      #prop[] = result[           "ListingStatus"]
      #prop[] = result[           "MapCoordinate"]
      #prop[] = result[        "ListAgentAgentID"]
      #prop[] = result[        "SaleAgentAgentID"]
      #prop[] = result[      "SaleOfficeOfficeID"]
      #prop[] = result[   "ModificationTimestamp"]
      #prop[] = result[   "SaleAgentNRDSMemberID"]
      prop.save
      photos.each_with_index do |data, index|
        prop.images.create(image: data.body)
        ## -- START: This is if your writing to a local filesystem --
        #dirname = "./public/photos/#{result['sysid']}"
        #unless File.directory?(dirname)
        #  FileUtils.mkdir_p(dirname)
        #end
        #File.open(dirname + "/property-#{index.to_s}.jpg", 'wb') do |file|
        #  file.write data.body
        #end
        ## -- END: This is if your writing to a local filesystem --
      end
    rescue => e
      puts 'Error: ' + e.message
      client.logout
      exit!
    end
  end
end
