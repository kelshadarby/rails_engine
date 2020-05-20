class Api::V1::MerchantItemsController < ApplicationController
  def index
    render json: Merchant.find(params[:id]).items
  end
  def show
    render json: Item.find(params[:id]).merchant
  end
end
