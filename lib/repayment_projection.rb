class RepaymentProjection
  attr_reader :listing, :kali, :ruth, :sba, :sources

  def initialize(listing)
    @listing = listing

    @sources = [
      @kali = MoneySource.new(max:  20_000, rate: 0.01, years:  5, price: listing.price),
      @ruth = MoneySource.new(max: 300_000, rate: 0.03, years:  5, price: listing.price - kali.amount_covering),
      @sba  = SBAMoneySource.new(owner_contributions: @kali.max + @ruth.max, rate: 0.06, years: 10, price: listing.price - kali.amount_covering - ruth.amount_covering),
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
    return unless listing.cashflow && listing.price < sources.sum(&:max)
    listing.cashflow - yearly
  end

  def cashflow_post_tax_and_repayment
    return unless listing.cashflow && listing.price < sources.sum(&:max)
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

class SBAMoneySource < MoneySource

  attr_accessor :owner_contributions

  def initialize(price:, rate:, years:, owner_contributions:, max: nil)
    @owner_contributions = owner_contributions
    super(price: price, rate: rate, years: years, max: max)
  end

  # SBA loan maxes out at 5k, and will require 10-25% owner downpayment.
  # I find 25 with less experience, but may be able to do small seller note
  # to count for some (only if it's held in abeyance until the SBA is paid off),
  # so using 20% here for projections (Kali can probably go closer to 15 for some web,
  # but don't want to rely on convincing them of that when running the numbers).
  def max
    [5_000_000, owner_contributions * 0.2].min
  end

end