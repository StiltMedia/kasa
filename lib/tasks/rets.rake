# Resources
#
# http://sparkplatform.com/docs/api_services/listings
# https://www.flexmls.com/developers/rets/tutorials/example-rets-session/
#
# Sample Response:
#                    "Type" => "RE1",
#              "PostalCode" => "33317",
#                "Bedrooms" => "7",
#               "CloseDate" => "",
#               "BathsFull" => "5",
#               "BathsHalf" => "1",
#              "LivingArea" => "7124",
#   "ModificationTimestamp" => "2015-09-24T10:33:03",
#      "ListOfficeOfficeID" => "FOSR01",
#        "ListAgentAgentID" => "0090905",
#               "ListPrice" => "950000",
#      "ListAgentFirstName" => "Dean Upton",
#               "ListingID" => "A1542756",
#                 "Remarks" => "One acre of beauty in the middle of Plantation.  Magnificent palace just completed with all amenities--call for info.  Owner/builder.....7124 sq. ft.--two kitchens....",
#              "ClosePrice" => "",
#      "SaleOfficeOfficeID" => "",
#        "SaleAgentAgentID" => "",
#           "ListingStatus" => "A",
#              "StreetName" => "BROWARD BL",
#            "StreetNumber" => "5361",
#           "MapCoordinate" => "",
#                    "City" => "PLANTATN",
#                   "State" => "FL",
#              "Directions" => "",
#   "SaleAgentNRDSMemberID" => ""
namespace :rets do
  namespace :pull do

    desc "Pull properties"
    task :properties => :environment do

      # Pass the :login_url, :username, :password and :version of RETS
      client = Rets::Client.new({
        metadata_cache: Rets::Metadata::FileCache.new("/tmp/metadata"),
        metadata_serializer: Rets::Metadata::JsonSerializer.new,
        login_url:      'http://sef.rets.interealty.com/Login.asmx/Login',
        username:       'guilRWSmo',
        password:       'gt5160ms',
        agent:          'RETS-Connector/1.2',
        ua_password:    '123456',
        version:        'RETS/1.5',
      })

      begin
        client.login
      rescue => e
        puts 'Error: ' + e.message
        exit!
      end

      # Get property
      # Pass :first or :all
      # Required. :search_type (Property, Agent, Office)
      # Required. :class (Condo, Commerical, ...) or (A for Residential, B for Lots and Land, C for Residential Rentals)
      # Required. :query
      # :limit
      property = client.find :all, {
        #metadata:       true,
        #format:         'COMPACT',
        search_type:    'Property',
        class:          '1',
        standard_name:  1,
        #query:         '(246=|A,B,C,CS,PS,Q,T,W,X),(61=|BROWARD,DADE,GLADES,HENDRY,INDNRIV,MARTIN,OKEECHB,OTHER,PALMBCH,STLUCIE),(19=|20),(25=3+)',
        #query:         '(246=|A,B,C,CS,PS,Q,T,W,X),(61=|BROWARD,DADE,GLADES,HENDRY,INDNRIV,MARTIN,OKEECHB,OTHER,PALMBCH,STLUCIE)',
        #query:         '(246=|A),(61=|BROWARD,DADE,GLADES,HENDRY,INDNRIV,MARTIN,OKEECHB,OTHER,PALMBCH,STLUCIE)',
        query:          '(246=|A),(61=|BROWARD)',
        limit:          4,
        resolve:        true
      }

      puts 'received property: '
      puts property.inspect

      property.each do |result|

        prop = Property.find_or_initialize_by(mls_listing_number: result["ListingID"])
        debugger
        prop[:city] = result["City"]
        prop[:bedrooms] = result["Bedrooms"]
        prop[:current_list_price] = result["ListPrice"]
        prop[:full_bathrooms] = result["BathsFull"]
        prop[:half_bathrooms] = result["BathsHalf"]
        prop[:zip] = result["PostalCode"]
        prop[:mls_name] = result["ListAgentFirstName"]
        prop[:listing_office] = result["ListOfficeOfficeID"]
        prop[:description] = result["Remarks"]
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

        #  condition                     :string
        #  description                   :text
        #  fake_favorited                :integer
        #  favorited                     :integer
        #  featured_content_type         :string
        #  featured_file_name            :string
        #  featured_file_size            :integer
        #  featured_updated_at           :datetime
        #  full_address                  :string
        #  garage_size                   :integer
        #  has_garage                    :boolean
        #  image_id                      :integer
        #  last_update_description       :text
        #  listing_office                :string
        #  location                      :string
        #  lot_sqft                      :decimal(, )
        #  mls_date_added                :date
        #  mls_date_modified             :date
        #  mls_sources                   :string
        #  property_type                 :string
        #  short_description             :text
        #  short_last_update_description :text
        #  sold_price                    :decimal(, )
        #  sqft                          :decimal(, )
        #  sqft_price                    :decimal(, )
        #  status                        :string
        #  street_name                   :string
        #  street_number                 :integer
        #  unit_number                   :string
        #  updated_at                    :datetime         not null
        #  year_built                    :integer
        #  zip                           :integer

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

      end

      # Get all photos (*) for MLS ID 'mls_id'
      # Pass :object_id (ie '0', '1,2', wildcard '*')
      # The pass :resource (Property, Agent, MetaData, ...), :object_type (Photo, PhotoLarge), :rescource_id (ID of agent, MLS, ...)
      #photos = client.objects '*', {
      #  resource: 'Property',
      #  object_type: 'Photo',
      #  resource_id: '342371208'
      #}
      #photos.each_with_index do |data, index|
      #  File.open("property-#{index.to_s}.jpg", 'wb') do |file|
      #    file.write data.body
      #  end
      #end
      #puts photos.length.to_s + ' photos saved.'

      client.logout

    end
  end
end
