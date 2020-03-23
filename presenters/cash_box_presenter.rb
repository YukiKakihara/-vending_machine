require_relative '../models/cash_box'

class CashBoxPresenter
  def initialize(initial_stock)
    @cash_box = CashBox.new(initial_stock)
  end

  def add_user_payment!(japanese_cash_name)
    @cash_box.add_user_payment!(japanese_cash_name)
  end

  def get_user_payments_sum
    @cash_box.user_payments_sum
  end

  def user_buy!(price)
    @cash_box.user_buy!(@cash_box.user_payments_sum, price)
  end

  def display_profit_check
    "売上：#{@cash_box.profit_sum}円\n釣り銭ストック：#{display_change_stock}"
  end

  def display_refund
    statement = "合計：#{@cash_box.user_payments_sum}円"
    statement += ' / '
    statement += "お釣り：#{display_user_change}"
  end

  def display_user_payments_sum
    "合計：#{@cash_box.user_payments_sum}円"
  end

  private

  def display_user_change
    return 'なし' if @cash_box.no_user_payments?

    change_cash = []
    cash_names  = @cash_box.user_payments.keys

    cash_names.each do |cash_name|
      change_cash << Array.new(@cash_box.user_payments[cash_name], japanese_name(cash_name))
    end

    change_cash.flatten.join(', ')
  end

  def display_change_stock
    CashBox::CASH.map { |cash| "#{cash[:japanese_name]}：#{@cash_box.send(cash[:name])}枚" }.flatten.join(', ')
  end

  def japanese_name(cash_name)
    CashBox::CASH.each { |cash| break cash[:japanese_name] if cash[:name] == cash_name }
  end
end
