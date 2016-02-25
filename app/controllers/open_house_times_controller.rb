class OpenHouseTimesController < ApplicationController
  before_action :set_open_house_time, only: [:show, :edit, :update, :destroy]

  # GET /open_house_times
  # GET /open_house_times.json
  def index
    @open_house_times = OpenHouseTime.all
  end

  # GET /open_house_times/1
  # GET /open_house_times/1.json
  def show
  end

  # GET /open_house_times/new
  def new
    @open_house_time = OpenHouseTime.new
  end

  # GET /open_house_times/1/edit
  def edit
  end

  # POST /open_house_times
  # POST /open_house_times.json
  def create
    @open_house_time = OpenHouseTime.new(open_house_time_params)

    respond_to do |format|
      if @open_house_time.save
        format.html { redirect_to @open_house_time, notice: 'Open house time was successfully created.' }
        format.json { render :show, status: :created, location: @open_house_time }
      else
        format.html { render :new }
        format.json { render json: @open_house_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /open_house_times/1
  # PATCH/PUT /open_house_times/1.json
  def update
    respond_to do |format|
      if @open_house_time.update(open_house_time_params)
        format.html { redirect_to @open_house_time, notice: 'Open house time was successfully updated.' }
        format.json { render :show, status: :ok, location: @open_house_time }
      else
        format.html { render :edit }
        format.json { render json: @open_house_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /open_house_times/1
  # DELETE /open_house_times/1.json
  def destroy
    @open_house_time.destroy
    respond_to do |format|
      format.html { redirect_to open_house_times_url, notice: 'Open house time was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_open_house_time
      @open_house_time = OpenHouseTime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def open_house_time_params
      params.require(:open_house_time).permit(:odate, :start_time, :end_time, :advert_id)
    end
end
