require 'spec_helper'


describe RepaymentProjection do
  let(:listing)    { Hashie::Mash.new(price: 500_000, cashflow: 250_000) }
  let(:projection) { RepaymentProjection.new(listing) }

  before(:each) do
    # Hardcoding these params since they may change without changing the algorithm,
    # but the "correct" answers below require these settings.
    kali = MoneySource.new(max:  20_000, rate: 0.01, years:  5, price: listing.price)
    ruth = MoneySource.new(max: 300_000, rate: 0.03, years:  5, price: listing.price - kali.amount_covering)
    sba  = MoneySource.new(              rate: 0.06, years: 10, price: listing.price - kali.amount_covering - ruth.amount_covering)

    allow(projection).to receive(:kali).and_return    kali
    allow(projection).to receive(:ruth).and_return    ruth
    allow(projection).to receive(:sba).and_return     sba
    allow(projection).to receive(:sources).and_return [kali, ruth, sba]
  end

  it "calculates payments for Kali" do
    expect(projection.kali.monthly).to eq 342
  end

  it "calculates payments for Ruth" do
    expect(projection.ruth.monthly).to eq 5391
  end

  it "calculates payments for SBA" do
    expect(projection.sba.monthly).to eq 1999
  end

  it "calculates total payments" do
    expect(projection.monthly).to eq 7732
    expect(projection.yearly).to eq (7732 * 12)
  end

  it "calculates cost of loan" do
    expect(projection.loan_cost).to eq 83860
  end

  it "calculates after-loan cashflow" do
    expect(projection.cashflow_after_repayment).to eq 157216
  end

end