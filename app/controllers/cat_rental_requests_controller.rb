class CatRentalRequestsController < ApplicationController

  def new
    @cats = Cat.all
    render :new
  end

  def create
    @cat = CatRentalRequest.new(rental_request_params)
    if @cat.save
      redirect_to cat_url(@cat.cat_id)
    else
      render plain: @cat.errors.full_messages
    end
  end

  private

  def rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
