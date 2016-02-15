class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy]

  # GET /properties
  # GET /properties.json
  def index
    @properties = Property.all
  end

  def img_rm
    property = Property.find(params[:propertyid])   
    logger.debug "DB8 images_tot waz #{property.images_tot}"
    property.images_tot -= 1
    logger.debug "DB8 images_tot waz #{property.images_tot} after"
    property.save
    render json: { result: "ok" }
  end

  def img_post
    @property = Property.find(params[:propertyid])
    @property.images_tot = 0 if ! @property.images_tot
    @property.images_tot += 1
    result_1 = @property.save
    ext = File.extname(params[:files][0].original_filename)
    file_name = "#{@property.listing_id}_#{@property.images_tot-1}.jpg"
    require 'aws-sdk'
    @s3 = nil
    s3_login = 'AKIAJ6P4PCOUQL5GW52Q'
    s3_password = '67/kSQQuGN/cgvtmREDpBu8jYsLTeA0nuP3LI/tW'
    s3_bucket = 'kasa-staging-02'
    @s3 = Aws::S3::Resource.new(region:'us-west-2',
      credentials: Aws::Credentials.new(s3_login, s3_password))
    connect_to_s3() if ! @s3
    logger.debug "DB8 saving #{file_name}"
    obj = @s3.bucket(s3_bucket).object(file_name)
    result_2 = obj.upload_file(params[:files][0].tempfile.path)
    if result_1 && result_2
      render json: { 
        files: [ 
          { name: file_name,
            size: 100,
            zurl: "http:\/\/example.org\/files\/picture1.jpg",
            zthumbnailUrl: "http:\/\/example.org\/files\/thumbnail\/picture1.jpg",
            zdeleteUrl: "http:\/\/example.org\/files\/picture1.jpg",
            zdeleteType: "DELETE"  } 
        ]
      }
    end
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
  end

  # GET /properties/new
  def new
    @property = Property.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties
  # POST /properties.json
  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: 'Property was successfully created.' }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to properties_url, notice: 'Property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      #params[:property]
      params.require(:property).permit(:address, :city, :state, :price,
        :ptype, :beds, :garage, :area, :floor, :built, :remarks, :open_house_beg, :open_house_end)
    end
end
