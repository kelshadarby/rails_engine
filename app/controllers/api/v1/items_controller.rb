class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params))
  end

  def update
    render json: ItemSerializer.new(Item.update(item_params))
  end

  def destroy
    item = Item.find(params[:id])
    Item.delete(item)
    render json: ItemSerializer.new(item)
  end

  def find
      if params[:id] || params[:unit_price]
        item = Item.find_by(item_find_params)
      else
        item = Item.where("#{item_find_params.keys[0]} ILIKE ?", "%#{item_find_params.values[0]}%").first
      end

    render json: ItemSerializer.new(item)
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def item_find_params
      params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
    end
end
