# coding: utf-8
class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    if (params[:filter] == 'open_tickets')
      @tickets = current_user.open_tickets 
    elsif (params[:filter] == 'open_awaiting_tickets')
      @tickets = current_user.open_awaiting_tickets
    elsif (params[:filter] == 'open_tickets_admin')
      @tickets = User.open_tickets_admin
    elsif (params[:filter] == 'open_awaiting_tickets_admin')
      @tickets = User.open_awaiting_tickets_admin
    else
      @tickets = Ticket.all
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    render layout: "metronic_layout"
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.create(state: "open", tuser: current_user.id)
    @memo = Memo.new(body: "Your message", ticket_id: @ticket.id, mfrom: current_user.id)
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to "/pages/user_dashboard", notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /tickets/1/add_memo
  def add_memo
    mfrom = current_user.id
    mfrom = User.find_by_email("kasa@kasa-staging.herokuapp.com").id if current_user.admin == true
    @new_memo = Memo.create(ticket_id: params[:id], mfrom: mfrom, body: params[:body])
    rts = (render_to_string :partial => 'timeline', :locals => { :ticket => Ticket.find(params[:id])  })
    render json: { content: rts  }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:state, :subject)
    end
end
