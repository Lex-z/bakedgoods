class FoodsController < ApplicationController

  before_action :current_user_is_owner, :only => [:edit, :update, :destroy]

  def current_user_is_owner
    @food = Food.find(params[:id])
    if current_user.id != @food.user_id
      redirect_to "/foods", :alert => "Access denied. You do not have permission to perform this action."
    end
  end

  def index
    @foods = Food.all
  end

  def myinventory
    @foods = Food.where(:user_id => current_user.id)
  end

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new
    @food.foodname = params[:foodname]
    @food.description = params[:description]
    @food.user_id = params[:user_id]
    @food.servings_avail = params[:servings_avail]
    @food.servings_purch = params[:servings_purch]
    @food.price = params[:price]
    @food.image = params[:image]
    @food.pickuptime_start = DateTime.strptime(params[:pickuptime_start], '%m/%d/%Y %H:%M')
    @food.pickuptime_end = DateTime.strptime(params[:pickuptime_end], '%m/%d/%Y %H:%M')
    @food.taste_rate = params[:taste_rate]
    @food.portion_rate = params[:portion_rate]
    @food.value_rate = params[:value_rate]

    if @food.save
      redirect_to "/foods", :notice => "Food created successfully."
    else
      render 'new'
    end
  end

  def edit
    @food = Food.find(params[:id])
  end

  def update
    @food = Food.find(params[:id])

    @food.foodname = params[:foodname]
    @food.description = params[:description]
    @food.user_id = params[:user_id]
    @food.servings_avail = params[:servings_avail]
    @food.servings_purch = params[:servings_purch]
    @food.price = params[:price]
    @food.image = params[:image]
    @food.pickuptime_start = DateTime.strptime(params[:pickuptime_start], '%m/%d/%Y %H:%M')
    @food.pickuptime_end = DateTime.strptime(params[:pickuptime_end], '%m/%d/%Y %H:%M')
    @food.taste_rate = params[:taste_rate]
    @food.portion_rate = params[:portion_rate]
    @food.value_rate = params[:value_rate]


    if @food.save
      redirect_to "/foods", :notice => "Food updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @food = Food.find(params[:id])

    @food.destroy

    redirect_to "/foods", :notice => "Food deleted."
  end
end
