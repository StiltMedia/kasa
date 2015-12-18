require 'open3'

class PagesController < ApplicationController
  include ActionController::Live
  def landing
  end

  def browse
    if params[:baths] == 'All'
      params[:baths] = nil
      session[:browse_baths] ='All'
    end
    if params[:beds] == 'All'
      params[:beds] = nil
      session[:browse_beds] ='All'
    end

    session[:browse_search] = params[:search] if params.has_key? 'search'
    session[:browse_price] = params[:price] if params[:price].present?
    session[:browse_beds] = params[:beds] if params[:beds].present?
    session[:browse_baths] = params[:baths] if params[:baths].present?

    session[:browse_sort] = params[:sort] if params[:sort].present?
    session[:browse_page] = params[:page] if params[:page].present?

    session[:browse_beds] = 'All' if (!session[:browse_beds].present?) && (!params[:beds])
    session[:browse_baths] = 'All' if (!session[:browse_baths].present?) && (!params[:baths])
    session[:browse_price] = 'Any Price' if (!session[:browse_price].present?) && (!params[:price])
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

    if session[:browse_price] == '<100000'
      @properties = Property.where("price < 100000")
    elsif session[:browse_price] == '>100000'
      @properties = Property.where("price >= 100000 AND price < 199999")
    elsif session[:browse_price] == '>200000'
      @properties = Property.where("price >= 200000 AND price < 299999")
    elsif session[:browse_price] == '>300000'
      @properties = Property.where("price >= 300000 AND price < 399999")
    elsif session[:browse_price] == '>400000'
      @properties = Property.where("price >= 400000 AND price < 499999")
    elsif session[:browse_price] == '>500000'
      @properties = Property.where("price >= 500000 AND price < 599999")
    end
    if session[:browse_search].present?
      @properties = Property.where("address ILIKE '%#{session[:browse_search]}%' OR listing_id ILIKE '%#{session[:browse_search]}%'  OR city ILIKE '%#{session[:browse_search]}%' OR county ILIKE '%#{session[:browse_search]}%' OR zip ILIKE '%#{session[:browse_search]}%'")
    end

    # count, for the  'Viewing page 1 of 5' Found panel
    @result_count = @properties.all.size
    

    #step 2 - sorting
    if session[:browse_sort] == 'Newest Listings'
      @properties = @properties.order(date: :desc).paginate(:page => session[:browse_page], :per_page => 10, :total_entries => 25)
    elsif session[:browse_sort] == 'Highest Price'
      @properties = @properties.order(price: :desc).paginate(:page => session[:browse_page], :per_page => 10, :total_entries => 25)
    elsif session[:browse_sort] == 'Lowest Price'
      @properties = @properties.order(:price).paginate(:page => session[:browse_page], :per_page => 10, :total_entries => 25)
    else
      @properties = @properties.order(date: :desc).paginate(:page => session[:browse_page], :per_page => 10, :total_entries => 25)
    end
  end

  def fetch
    response.headers['Content-Type'] = 'text/html'
    response.stream.write "<br>Running rake kasa:fetch PHOTOS=1\n"
    cmd = 'rake kasa:fetch PHOTOS=1'
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
