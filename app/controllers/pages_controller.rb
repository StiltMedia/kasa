require 'open3'

class PagesController < ApplicationController
  include ActionController::Live
  def landing
  end
  def browse
    if params[:sort] == 'Newest Listings'
      @properties = Property.order(date: :desc).paginate(:page => params[:page], :per_page => 5, :total_entries => 15)
    elsif params[:sort] == 'Highest Price'
      @properties = Property.order(price: :desc).paginate(:page => params[:page], :per_page => 5, :total_entries => 15)
    elsif params[:sort] == 'Lowest Price'
      @properties = Property.order(:price).paginate(:page => params[:page], :per_page => 5, :total_entries => 15)
    else
      @properties = Property.order(date: :desc).paginate(:page => params[:page], :per_page => 5, :total_entries => 15)
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
