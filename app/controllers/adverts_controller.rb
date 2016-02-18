class AdvertsController < ApplicationController
  before_action :set_advert, only: [:show, :edit, :update, :destroy]

  # GET /adverts
  # GET /adverts.json
  def index
    if params[:keywordfilter].present?
      @adverts = current_user.adverts.select do |advert|
        advert.property.address.include? URI.unescape(params[:keywordfilter])
      end
    elsif params[:monthfilter].present?
      @adverts = current_user.adverts
      @adverts = @adverts.select do |advert|
        advert.property.date && ( advert.property.date.strftime("%B") == Time.at(params[:monthfilter].to_i).strftime("%B") )
      end
    else
      @adverts = current_user.adverts
    end
  end

  # GET /adverts/1
  # GET /adverts/1.json
  def show
  end

  # GET /adverts/new
  def new
    if params[:step] == "1"
      @property = Property.new(listing_id: "FE9E" + "0001", images_tot: 0)
      @property.save
      @advert = Advert.new(property_id: @property.id, user_id: current_user.id)
      @advert.save
      Feed.create(
        user_id: nil,
        message: "#{current_user.email} started listing #{@advert.property.listing_id}"
      )
    else
      @property = Property.find(params[:propertyid])
    end
    @images_tot = @property.images_tot || 0
  end

  # GET /adverts/1/edit
  def edit
    redirect_to "/adverts/new?step=5&propertyid=#{Advert.find(params[:id]).property_id}"
  end

  # POST /adverts
  # POST /adverts.json
  def create
    @advert = Advert.new(advert_params)

    respond_to do |format|
      if @advert.save
        format.html { redirect_to @advert, notice: 'Advert was successfully created.' }
        format.json { render :show, status: :created, location: @advert }
      else
        format.html { render :new }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adverts/1
  # PATCH/PUT /adverts/1.json
  def update
    respond_to do |format|
      if @advert.update(advert_params)
        format.html { redirect_to @advert, notice: 'Advert was successfully updated.' }
        format.json { render :show, status: :ok, location: @advert }
      else
        format.html { render :edit }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    byebug
    @advert.destroy
    respond_to do |format|
      format.html {
        if params[:redir_to] == "back"
          redirect_to :back, notice: 'Advert was successfully destroyed.' 
        else
          redirect_to adverts_url, notice: 'Advert was successfully destroyed.' 
        end
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advert
      @advert = Advert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advert_params
      params.require(:advert).permit(:user_id, :property_id, :seed, :approved)
    end
end