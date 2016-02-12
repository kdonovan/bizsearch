class RepaymentProjection
  attr_reader :listing, :kali, :ruth, :sba, :sources

  def initialize(listing)
    @listing = listing

    @sources = [
      @kali = MoneySource.new(max:  20_000, rate: 0.01, years:  5, price: listing.price),
      @ruth = MoneySource.new(max: 300_000, rate: 0.03, years:  5, price: listing.price - kali.amount_covering),
      @sba  = MoneySource.new(              rate: 0.06, years: 10, price: listing.price - kali.amount_covering - ruth.amount_covering),
    ]
  end

  def monthly
    sources.sum(&:monthly)
  end

  def yearly
    sources.sum(&:yearly)
  end

  def loan_cost
    sources.sum(&:loan_cost)
  end

  def cashflow_after_repayment
    return unless listing.cashflow
    listing.cashflow - yearly
  end

end


module ProjectionCalculations

  def monthly_payment(principal, years, annual_rate)
    rate_per_period   = annual_rate / 12.0
    number_of_periods = years * 12

    denom = ((1 + rate_per_period) ** number_of_periods) - 1
    exact = principal * (rate_per_period + (rate_per_period / denom))

    exact.ceil
  end

end


class MoneySource
  include ProjectionCalculations

  attr_reader :max, :rate, :years, :price

  # rate = annual percentage rate (e.g. 0.05 = 5% per year)
  def initialize(price:, max: nil, rate:, years:)
    @price, @rate, @years, @max = [price, rate, years, max]
  end

  def amount_covering
    max ? [max, price].min : price
  end

  def monthly
    monthly_payment(amount_covering, years, rate)
  end

  def yearly
    monthly * 12
  end

  def loan_cost
    (yearly * years) - amount_covering
  end

end
