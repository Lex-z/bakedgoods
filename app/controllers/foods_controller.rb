class FoodsController < ApplicationController
  def index
    @foods = Food.all
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
    @food.pickuptime_start = params[:pickuptime_start]
    @food.pickuptime_end = params[:pickuptime_end]
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
    @food.pickuptime_start = params[:pickuptime_start]
    @food.pickuptime_end = params[:pickuptime_end]
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
