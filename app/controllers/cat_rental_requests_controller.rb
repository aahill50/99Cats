class CatRentalRequestsController < ApplicationController
  before_action(only: [:approve, :deny]) do
    @curr_cat = CatRentalRequest.find(params[:id]).cat
    unless current_user == @curr_cat.owner
      flash[:errors] = "Not ALLOWEEDDD!!!!"
      redirect_to cat_url(@curr_cat)
    end
  end

  def new

    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(rental_params)
    @cat_rental_request.user_id = current_user.id
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat= @cat_rental_request.cat

    ActiveRecord::Base.transaction do
      @cat_rental_request.approve!
      @cat_rental_request.overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
      rescue ActiveRecord::RecordInvalid
        flash[:errors] = @cat_rental_request.errors.full_messages
       redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end


  private
  def rental_params
    params.require(:cat_rental_request)
    .permit(:cat_id, :start_date,:end_date)
  end

end
