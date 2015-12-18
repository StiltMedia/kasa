class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def favorite_on
    error_msg = { :status => "error", :message => "error" }
    ok_msg = { :status => "ok", :message => "success" }
    a = Favorite.where(user_id: params[:user_id], property_id: params[:property_id])
    if a.present?
      render :json => ok_msg and return
    else
      Favorite.create(user_id: params[:user_id], property_id: params[:property_id])
    end
    render :json => ok_msg
  end

  def favorite_off
    error_msg = { :status => "error", :message => "error" }
    ok_msg = { :status => "ok", :message => "success" }
    a = Favorite.where(user_id: params[:user_id], property_id: params[:property_id]).first
    if a.present?
      a.destroy
      render :json => ok_msg and return
    end
    render :json => ok_msg
  end
end
