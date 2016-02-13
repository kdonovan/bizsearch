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

  def cashflow_post_tax_and_repayment
    return unless listing.cashflow
    ((1 - tax_rate) * listing.cashflow) - yearly
  end

  def tax_rate
    base = 0.33

    # ROUGH ESTIMATES! http://www.money-zine.com/financial-planning/tax-shelter/state-income-tax-rates/
    state = case listing&.state
    when %w(AK FL NV SD TX WA WY) then 0
    when 'CA' then 0.10
    when 'OR' then 0.09
    when 'HI' then 0.08
    when 'CO' then 0.047
    else 0.08 # rough guess for the others
    end

    base + state
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
