class Food < ActiveRecord::Base

  has_many :orders, dependent: :destroy
  belongs_to :user

  validates :foodname, presence: true
  validates :description, presence: true
  validates :servings_avail, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :servings_purch, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0, :less_than => 10}
  validates :pickuptime_start, :presence => true
  validates :pickuptime_end, :presence => true

  validates :taste_rate, numericality: { only_integer: true}
  validates :portion_rate, numericality: { only_integer: true}
  validates :value_rate, numericality: { only_integer: true}

end
