class NegotiationsController < ApplicationController
  before_action :set_negotiation, only: [:show, :edit, :update, :destroy]

  # # GET /negotiations
  # # GET /negotiations.json
  # def index
  #   @negotiations = Negotiation.all
  # end
  # 
  # # GET /negotiations/1
  # # GET /negotiations/1.json
  # def show
  # end
  # 
  # # GET /negotiations/new
  # def new
  #   @negotiation = Negotiation.new
  # end
  # 
  # # GET /negotiations/1/edit
  # def edit
  # end

  # POST /negotiations
  # POST /negotiations.json
  def create
    raise "Error" if negotiation_params["ntype"] == "zaccepted"
    sleep 0.3
    @negotiation = Negotiation.new(negotiation_params)   
    respond_to do |format|
      if @negotiation.save
        format.html { redirect_to @negotiation, notice: 'Negotiation was successfully created.' }
        format.json { render json: { status: "ok"  } }
      else
        format.html { render :new }
        format.json { render json: @negotiation.errors, status: :unprocessable_entity }
      end
    end

    # sleep 0.2
    # params[:negotiation][:ndate] = Time.now if params[:negotiation][:ndate].blank?
    # params[:negotiation][:details] = "Accepted" if params[:negotiation][:details].blank? && params[:negotiation][:ntype] == "accept-offer"
    # params[:negotiation][:details] = "Declined" if params[:negotiation][:details].blank? && params[:negotiation][:ntype] == "decline-offer"
    # params[:negotiation][:details] = "Countered" if params[:negotiation][:details].blank? && params[:negotiation][:ntype] == "counter"
    # params[:negotiation][:details] = "Accepted (Counter)" if params[:negotiation][:details].blank? && params[:negotiation][:ntype] == "accept-counter"
    # params[:negotiation][:details] = "Declined (Counter)" if params[:negotiation][:details].blank? && params[:negotiation][:ntype] == "decline-counter"
    # 
    # @negotiation = Negotiation.new(negotiation_params)
    # 
    # respond_to do |format|
    #   if @negotiation.save
    #     a = (render_to_string :partial => '/shared/offers', :locals => {   })
    #     format.html { redirect_to @negotiation, notice: 'Negotiation was successfully created.' }
    #     format.json { render json: { content: a } }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @negotiation.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # # PATCH/PUT /negotiations/1
  # # PATCH/PUT /negotiations/1.json
  # def update
  #   respond_to do |format|
  #     if @negotiation.update(negotiation_params)
  #       format.html { redirect_to @negotiation, notice: 'Negotiation was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @negotiation }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @negotiation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /negotiations/1
  # # DELETE /negotiations/1.json
  # def destroy
  #   @negotiation.destroy
  #   respond_to do |format|
  #     format.html { redirect_to negotiations_url, notice: 'Negotiation was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_negotiation
      @negotiation = Negotiation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def negotiation_params
      params.require(:negotiation).permit(:buyer_id, :seller_id, :ntype,
        :amount, :property_id, :ndate, :direction, :offer_id)
    end
end
