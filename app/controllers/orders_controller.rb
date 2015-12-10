class OrdersController < ApplicationController

  before_action :current_user_is_owner, :only => [:edit, :update, :destroy]

  def current_user_is_owner
    @order = Order.find(params[:id])
    if current_user.id != @order.user_id
      redirect_to "/orders", :alert => "Access denied. You do not have permission to perform this action."
    end
  end

  def index
    @orders = Order.all
  end

  def myorders
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @food = Food.find(params[:id])
    @order = Order.new
  end

  def create
    @order = Order.new
    @order.user_id = params[:user_id]
    @order.food_id = params[:food_id]
    @order.quantity = params[:quantity]
    @order.pickuptime = DateTime.strptime(params[:pickuptime], '%m/%d/%Y %H:%M')
    @order.note = params[:note]

    if @order.quantity > @order.food.servings_avail
      redirect_to :back, :notice => "Order greater than quantity available! Order not placed. Please change your quantity."
    else
      @order.food.servings_avail = @order.food.servings_avail - @order.quantity
      @order.food.servings_purch = @order.food.servings_purch + @order.quantity

      if @order.save
       @order.food.save
       redirect_to "/myorders", :notice => "Order created successfully! Your seller will email you directly with confirmation and pickup details."
     else
       render 'new'
     end
   end
 end

 def edit
  @order = Order.find(params[:id])
end

def update
  @order = Order.find(params[:id])
  @order.user_id = params[:user_id]
  @order.food_id = params[:food_id]
  @order.quantity = params[:quantity]
  @order.pickuptime = DateTime.strptime(params[:pickuptime], '%m/%d/%Y %H:%M')
  @order.note = params[:note]

  @startquantity = params[:startquantity].to_i
  @changequantity = @order.quantity - @startquantity

  if @changequantity > @order.food.servings_avail
   redirect_to :back, :notice => "Order greater than quantity available! Order not placed. Please change your quantity."
 else
  @order.food.servings_avail = @order.food.servings_avail - @changequantity
  @order.food.servings_purch = @order.food.servings_purch + @changequantity

  if @order.save
    @order.food.save
    redirect_to "/myorders", :notice => "Order updated successfully."
  else
    render 'edit'
  end
end
end

def destroy
  @order = Order.find(params[:id])
  @order.food.servings_avail = @order.food.servings_avail + @order.quantity
  @order.food.servings_purch = @order.food.servings_purch - @order.quantity
  @order.food.save
  @order.destroy
  redirect_to "/myorders", :notice => "Order deleted."
end

end
