class OrdersController < ApplicationController

  before_action :current_user_is_owner, :only => [:edit, :update]
  before_action :current_user_is_owner_or_seller, :only => [:destroy]

  def current_user_is_owner
    @order = Order.find(params[:id])
    if current_user.id != @order.user_id
      redirect_to "/orders", :alert => "Access denied. You do not have permission to perform this action."
    else
    end
  end

  def current_user_is_owner_or_seller
    @order = Order.find(params[:id])
    if current_user.id = @order.user_id || current_user.id = @order.food.user_id
    else
      redirect_to "/orders", :alert => "Access denied. You do not have permission to perform this action."
    end
  end

  def index
    @orders = Order.all
  end

  def myorders
    @orders = current_user.orders
  end

  def mysales
    @orders = Order.all
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

       #issues with figaro hiding api key, but mailgun id works.
       RestClient.post "https://api:key-xxxx"\
       "@api.mailgun.net/v3/#{ENV["mailgun_id"]}/messages",
       :from => "Heartbaked <mailgun@#{ENV["mailgun_id"]}>",
       :to => current_user.email,
       :subject => "Order number #{@order.id} created successfully!",
       :text => "Thank you for placing your order for #{@order.quantity} servings of #{@order.food.foodname} at $#{@order.food.price} each. The pickup time is #{@order.pickuptime}. Your seller #{@order.food.user.username} will be in contact with you shortly. Please email #{@order.food.user.username} at #{@order.food.user.email} if you encounter any issues."

       RestClient.post "https://api:key-xxxx"\
       "@api.mailgun.net/v3/#{ENV["mailgun_id"]}/messages",
       :from => "Heartbaked <mailgun@#{ENV["mailgun_id"]}>",
       :to => @order.food.user.email,
       :subject => "You have a sale! Order number #{@order.id} created successfully!",
       :text => "#{current_user.username} has placed an order for #{@order.quantity} servings of #{@order.food.foodname} at $#{@order.food.price} each. The pickup time is #{@order.pickuptime}. Please email #{current_user.username} at #{current_user.email} to confirm the pickup."

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

    RestClient.post "https://api:key-xxxx"\
    "@api.mailgun.net/v3/#{ENV["mailgun_id"]}/messages",
    :from => "Heartbaked <mailgun@#{ENV["mailgun_id"]}>",
    :to => "#{current_user.email}, #{@order.food.user.email}",
    :subject => "Order number #{@order.id} #{@order.food.foodname} has been modified!",
    :text => "Please log on to check the changes to Order number #{@order.id} and contact your buyer/seller with any issues."

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

  if @order.destroy
    RestClient.post "https://api:key-xxxx"\
    "@api.mailgun.net/v3/#{ENV["mailgun_id"]}/messages",
    :from => "Heartbaked <mailgun@#{ENV["mailgun_id"]}>",
    :to => "#{current_user.email}, #{@order.food.user.email}",
    :subject => "Order number #{@order.id} #{@order.food.foodname} has been canceled!",
    :text => "Please contact your buyer/seller with any issues."

    redirect_to "/myorders", :notice => "Order deleted."
  else
  end

end



end
