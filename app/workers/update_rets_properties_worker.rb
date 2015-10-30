include CustomRets
class UpdateRetsPropertiesWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'rets', :retry => false, :backtrace => true

  def perform(listing_id)
    client = rets_connection
    rets_query = '(246=|A,B,C,CS,PS,Q,T,W,X),(61=|BROWARD,DADE,GLADES,HENDRY,INDNRIV,MARTIN,OKEECHB,OTHER,PALMBCH,STLUCIE),(157=*' + listing_id + '*)'
    property = client.find :first, {
      class:          '1',
      limit:          1,
      query:          rets_query,
      resolve:        true,
      search_type:    'Property',
      standard_name:  1
    }
    debugger

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

    #photos = client.objects '*', {
    #  resource: 'Property',
    #  object_type: 'Photo',
    #  resource_id: result['sysid']
    #}

    #photos.each_with_index do |data, index|
    #  dirname = "./public/photos/#{result['sysid']}"
    #  unless File.directory?(dirname)
    #    FileUtils.mkdir_p(dirname)
    #  end
    #  File.open(dirname + "/property-#{index.to_s}.jpg", 'wb') do |file|
    #    file.write data.body
    #  end
    #end
    #puts photos.length.to_s + ' photos saved.'
    client.logout

  end
end
