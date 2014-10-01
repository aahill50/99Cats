class CatsController < ApplicationController
  before_filter(only: [:edit, :update, :destroy]) do
    unless current_user == Cat.find(params[:id]).owner
      redirect_to cats_url
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @cat_rental_requests = @cat.cat_rental_requests
    render :show
  end

  def destroy
    @cat = Cat.find(params[:id])
    fail
    if @cat.destroy
      redirect_to cats_url
    else
      flash[:errors] = @cat.errors.full_messages
      render :show
    end

  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  private
  def cat_params
    cat_attrs = [:name, :color, :sex, :description, :birth_date]
    params.require(:cat).permit(*cat_attrs)
  end

end
