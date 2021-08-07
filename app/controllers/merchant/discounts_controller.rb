class Merchant::DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
    @holidays = DateSwaggerService.new.next_three_holidays
  end

  def show
    @discount = Discount.find(params[:id])
  end
end
