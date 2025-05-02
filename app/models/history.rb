class History < ApplicationRecord
  belongs_to :user

  attr :ticker, :qty, :price, :buy_date, :sell_date, :sell_price

  def basis
    self[:qty].to_i * self[:price].to_f
  end

  def profit
    return 0 unless self[:sell_date]

    self[:qty].to_i * (self[:sell_price].to_f - self[:price].to_f)
  end
end
