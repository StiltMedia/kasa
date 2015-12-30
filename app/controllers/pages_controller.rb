require 'open3'

class PagesController < ApplicationController
  include ActionController::Live

  def search
  end

  def more_filters
  end

  def listing_details
    @listing = Property.find_by_listing_id(params[:listing_id])
  end

  def landing
  end

  def browse
    # remove commas, dollars and dots
    params[:min_price].gsub!(/[,\.\$\s]/,'') rescue nil
    params[:max_price].gsub!(/[,\.\$\s]/,'') rescue nil

    #remove asterisk
    params.delete :search if params[:search] == '*'

    if params[:browse_view].present?
      session[:browse_view] = params[:browse_view]
      params[:browse_view] = nil
    end

    if params[:baths] == 'All'
      params[:baths] = nil
      session[:browse_baths] ='All'
    end
    if params[:beds] == 'All'
      params[:beds] = nil
      session[:browse_beds] ='All'
    end

    if params[:min_price] == 'Any'
      params[:min_price] = nil
      session[:browse_min_price] ='Any'
    end

    if params[:max_price] == 'Any'
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
    session[:browse_sort] = 'Newest Listings' if (!session[:browse_sort].present?) && (!params[:sort])


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
      @properties = Property.where("price > #{session[:browse_min_price]}")
    end

    if session[:browse_max_price] =~ /\d+/
      @properties = Property.where("price < #{session[:browse_max_price]}")
    end

    if session[:browse_area] =~ /\d+/
      @properties = Property.where("area = #{session[:browse_area]}")
    end

    if session[:browse_area_lot] =~ /\d+/
      @properties = Property.where("area_lot = #{session[:browse_area_lot]}")
    end

    if session[:browse_search].present?
      @properties = Property.where("address ILIKE '%#{session[:browse_search]}%' OR listing_id ILIKE '%#{session[:browse_search]}%'  OR city ILIKE '%#{session[:browse_search]}%' OR county ILIKE '%#{session[:browse_search]}%' OR zip ILIKE '%#{session[:browse_search]}%'")
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

  def fetch
    response.headers['Content-Type'] = 'text/html'
    response.stream.write "<br>Running rake kasa:fetch LISTINGS=1 PHOTOS=0\n"
    cmd = 'rake kasa:fetch LISTINGS=1 PHOTOS=0'
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      while line = stdout.gets
        Rails.logger.debug line
        if line =~ /F95BA /  # F95BA indicates it's out puts lines
          l = line.sub(/F95BA /,'')
          if l =~ /NOBR/
            l.gsub!(/NOBR/,'')
            out_str = l
          else
            out_str = "<br>\n#{l}"
          end
          response.stream.write out_str
        end
      end
    end
    response.stream.close
  end
end
