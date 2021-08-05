class Merchant::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    item = Item.find(params[:id])
    if params[:status].present?
      item.update!(enabled: "disabled")
      redirect_to merchant_items_path
      flash[:success] = "Success: #{item.name} has been updated!"
    else
      item.update(item_params)
      redirect_to merchant_item_path
      flash[:success] = "Success: #{item.name} has been updated!"
    end
  end

  def new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to merchant_items_path
      flash[:success] = "Success: #{@item.name} has been created!"
    end
  end

  private
  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :enabled)
  end
end
