require 'open3'

class PagesController < ApplicationController
  include ActionController::Live
    include ActionView::Helpers::NumberHelper

  def user_dashboard
    @feeds = Feed.all.order(created_at: :desc) if current_user.admin
    @feeds = Feed.where(user_id: current_user.id).all.order(created_at: :desc) if current_user.admin != true

    redirect_to new_user_session_path if ! current_user
    render layout: 'metronic_layout'
  end

  def admin_dashboard
    redirect_to new_user_session_path if ! current_user
    @admins = User.where(admin: true).all
  end

  def best_in_place_update
    #not implementing for MVP
    render json: { status: "ok" }
  end

  def put_todo
    render json: { status: "ok" }
  end

  def offer_1
    @listing = Property.find_by_listing_id(params[:listing_id])
    @offer = Offer.create(user_id: current_user.id, property_id: Property.find_by_listing_id(params[:listing_id]).id)
  end

  def offer_2
    @offer = Offer.find(params[:offer_id])
    @offer.amount = params[:amount]
    @offer.save
  end

  def offer_3
    @offer = Offer.find(params[:offer_id])
    @offer.down_payment = params[:down_payment] if params.has_key?('down_payment')
    @offer.funding_source = params[:funding_source] if params.has_key?('funding_source')
    @offer.pre_approved = params[:pre_approved] if params.has_key?('pre_approved')
    @offer.save
  end

  def offer_4
    @offer = Offer.find(params[:offer_id])
    @offer.standard_terms = params[:standard_terms] if params.has_key?('standard_terms')
    @offer.downpayment_days = params[:downpayment_days] if params.has_key?('downpayment_days')
    @offer.planning_inspections = params[:planning_inspections] if params.has_key?('planning_inspections')
    @offer.request_pest_report = params[:request_pest_report] if params.has_key?('request_pest_report')
    @offer.request_one_year_home_warranty = params[:request_one_year_home_warranty] if params.has_key?('request_one_year_home_warranty')
    @offer.initial_deposit = params[:initial_deposit] if params.has_key?('initial_deposit')
    @offer.offer_expires = params[:offer_expires] if params.has_key?('offer_expires')
    @offer.special_instructions = params[:special_instructions] if params.has_key?('special_instructions')
    @offer.save
  end

  def offer_5
    @offer = Offer.find(params[:offer_id])
    @property = Property.find(@offer.property_id)
    @address = "#{@property.address.titleize} #{@property.city.titleize} #{@property.state}"
    @offer.first_name = params[:first_name] if params.has_key?('first_name')
    @offer.last_name = params[:last_name] if params.has_key?('last_name')
    @offer.address = params[:address] if params.has_key?('address')
    @offer.save

  end


  def offer_6
    @offer = Offer.find(params[:offer_id])
    dst = Advert.find_by_property_id(@offer.property_id).last.user_id rescue nil
    dst = 11 if !dst

    Negotiation.create(
      src: current_user.id,
      dst: dst,
      ndate: Time.now(),
      details: "Made Offer (#{number_to_currency(@offer.amount, precision: 0)})",
      ntype: "offer",
      property_id: @offer.property_id
    )
    Feed.create(
      user_id: nil,
      message: "#{current_user.email} created offer #{@offer.id}"
    )
  end

  def search
  end

  def more_filters
  end

  def listing_details
    @listing = Property.find_by_listing_id(params[:listing_id])
    raise "403 Forbidden" if ( @listing.non_rets && Advert.where(property_id: @listing.id).last.live != true )
    Hit.create(
      property_id: @listing.id,
      htime: Time.now(),
      user_id: (Advert.where(property_id: @listing.id).last.user_id rescue nil)
    )
  end

  def landing
    who = request.remote_ip
    who = current_user.email if current_user
    Feed.create(message: "visited landing page (#{who})", user_id: 4, icon: 'fa fa-flash')
  end

  def browse
    # remove commas, dollars and dots
    params[:min_price].gsub!(/[,\.\$\s]/,'') rescue nil
    params[:max_price].gsub!(/[,\.\$\s]/,'') rescue nil

    if params[:browse_view].present?
      session[:browse_view] = params[:browse_view]
      params[:browse_view] = nil
    end

    if params[:search] == '*'
      params.delete :search
      session[:browse_search] = nil
    end

    if params[:baths] == 'All'
      params[:baths] = nil
      session[:browse_baths] ='All'
    end

    if params[:beds] == 'All'
      params[:beds] = nil
      session[:browse_beds] ='All'
    end

    if params[:min_price] == 'Any' || params[:min_price] == '*'
      params[:min_price] = nil
      session[:browse_min_price] ='Any'
    end

    if params[:max_price] == 'Any' || params[:max_price] == '*'
      params[:max_price] = nil
      session[:browse_max_price] ='Any'
    end

    if params[:area] == 'Any'
      params[:area] = nil
      session[:browse_area] ='Any'
    end

    if params[:area_lot] == 'Any'
      params[:min_area_lot] = nil
      session[:browse_area_lot] ='Any'
    end



    session[:browse_search] = params[:search] if params.has_key? 'search'
    session[:browse_min_price] = params[:min_price] if params[:min_price].present? && params[:min_price] =~ /(\d+|Any)/
    session[:browse_max_price] = params[:max_price] if params[:max_price].present? && params[:max_price] =~ /(\d+|Any)/
    session[:browse_beds] = params[:beds] if params[:beds].present?
    session[:browse_baths] = params[:baths] if params[:baths].present?

    session[:browse_sort] = params[:sort] if params[:sort].present?
    session[:browse_page] = params[:page] if params[:page].present?

    session[:browse_beds] = 'All' if (!session[:browse_beds].present?) && (!params[:beds])
    session[:browse_baths] = 'All' if (!session[:browse_baths].present?) && (!params[:baths])
    session[:browse_min_price] = 'Any' if (!session[:browse_min_price].present?) && (!params[:min_price])
    session[:browse_max_price] = 'Any' if (!session[:browse_max_price].present?) && (!params[:max_price])

    session[:browse_area] = 'Any' if (!session[:browse_area].present?) && (!params[:area])
    session[:browse_area_lot] = 'Any' if (!session[:browse_area_lot].present?) && (!params[:area_lot])

    session[:browse_page] = 1 if (!session[:browse_page].present?) && (!params[:page])
    session[:browse_sort] = 'Highest Price' if (!session[:browse_sort].present?) && (!params[:sort])

    #step 1 - filtering
    @properties = Property.all

    if session[:browse_baths] == '>5'
      @properties = @properties.where("baths >= 5") if session[:browse_baths] != "All"
    else
      @properties = @properties.where(baths: session[:browse_baths]) if session[:browse_baths] != "All"
    end

    if session[:browse_beds] == '>5'
      @properties = @properties.where("beds >= 5") if session[:browse_beds] != "All"
    else
      @properties = @properties.where(beds: session[:browse_beds]) if session[:browse_beds] != "All"
    end

    if session[:browse_min_price] =~ /\d+/
      @properties = @properties.where("price > #{session[:browse_min_price]}")
    end

    if session[:browse_max_price] =~ /\d+/
      @properties = @properties.where("price < #{session[:browse_max_price]}")
    end

    if session[:browse_area] =~ /\d+/
      @properties = @properties.where("area = #{session[:browse_area]}")
    end

    if session[:browse_area_lot] =~ /\d+/
      @properties = @properties.where("area_lot = #{session[:browse_area_lot]}")
    end

    if session[:browse_search].present?
      @properties = @properties.where("address ILIKE '%#{session[:browse_search]}%' OR listing_id ILIKE '%#{session[:browse_search]}%'  OR city ILIKE '%#{session[:browse_search]}%' OR county ILIKE '%#{session[:browse_search]}%' OR zip ILIKE '%#{session[:browse_search]}%'")
    end

    # count, for the  'Viewing page 1 of 5' Found panel
    @result_count = @properties.all.size

    #step 2 - sorting
    if session[:browse_sort] == 'Newest Listings'
      @properties = @properties.order(date: :desc).paginate(:page => session[:browse_page], :per_page => 15, :total_entries => 60)
    elsif session[:browse_sort] == 'Highest Price'
      @properties = @properties.order(price: :desc).paginate(:page => session[:browse_page], :per_page => 15, :total_entries => 60)
    elsif session[:browse_sort] == 'Lowest Price'
      @properties = @properties.order(:price).paginate(:page => session[:browse_page], :per_page => 15, :total_entries => 60)
    else
      @properties = @properties.order(date: :desc).paginate(:page => session[:browse_page], :per_page => 15, :total_entries => 60)
    end
  end

  #def fetch
  #  response.headers['Content-Type'] = 'text/html'
  #  response.stream.write "<br>Running rake kasa:fetch LISTINGS=1 PHOTOS=0\n"
  #  cmd = 'rake kasa:fetch LISTINGS=1 PHOTOS=1'
  #  Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
  #    while line = stdout.gets
  #      Rails.logger.debug line
  #      if line =~ /F95BA /  # F95BA indicates it's out puts lines
  #        l = line.sub(/F95BA /,'')
  #        if l =~ /NOBR/
  #          l.gsub!(/NOBR/,'')
  #          out_str = l
  #        else
  #          out_str = "<br>\n#{l}"
  #        end
  #        response.stream.write out_str
  #      end
  #    end
  #  end
  #  response.stream.close
  #end
end
