class Order < ActiveRecord::Base

  belongs_to :food
  belongs_to :user

  validates :user, presence: true
  validates :food, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1}

end
