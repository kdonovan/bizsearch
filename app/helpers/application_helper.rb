module ApplicationHelper

  def dollars(n)
    number_to_currency n, precision: 0
  end

end
