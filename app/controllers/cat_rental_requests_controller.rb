class CatRentalRequestsController < ApplicationController
  def new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(rental_params)
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end



  private
  def rental_params
    params.require(:cat_rental_request)
    .permit(:cat_id, :start_date,:end_date)
  end

end
