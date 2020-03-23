require_relative '../errors/cash_box_errors'

class CashBox
  CASH = [
    { name: :ten_yen_coin, value: 10, japanese_name: '10円玉' },
    { name: :fifty_yen_coin, value: 50, japanese_name: '50円玉' },
    { name: :hundred_yen_coin, value: 100, japanese_name: '100円玉' },
    { name: :five_hundred_yen_coin, value: 500, japanese_name: '500円玉' },
    { name: :thousand_yen_bill, value: 1000, japanese_name: '1000円札' },
  ].freeze

  attr_reader :user_payments
  CASH.each { |cash| attr_reader cash[:name] }

  def initialize(initial_stock)
    @user_payments = initialized_user_payments

    CASH.each do |cash|
      cash_name = cash[:name]
      stock     = initial_stock[cash_name].to_i
      eval "@#{cash_name} = stock"
    end
  end

  def add_user_payment!(japanese_cash_name)
    CASH.each do |cash|
      next unless cash[:japanese_name] == japanese_cash_name

      @user_payments[cash[:name]] += 1
      break
    end
  end

  def no_user_payments?
    user_payments_sum.zero?
  end

  def profit_sum
    CASH.inject(0) { |result, cash| eval "result += @#{cash[:name]} * cash[:value]" }
  end

  def user_buy!(sum, price)
    payment        = @user_payments
    @user_payments = initialized_user_payments

    begin
      add_user_charge! prepare_change(sum - price)
      add_profit!(payment)
      true
    rescue NoChargeError
      @user_payments = payment
      false
    end
  end

  def user_payments_sum
    CASH.inject(0) do |result, cash|
      result += @user_payments[cash[:name]] * cash[:value]
    end
  end

  private

  def add_profit!(payments)
    payments.keys.each do |cash_name|
      add_stock = payments[cash_name]
      eval "@#{cash_name} += add_stock"
    end
  end

  def add_user_charge!(addition)
    addition.keys.each { |cash_name| @user_payments[cash_name] += addition[cash_name] }
  end

  def cash_name_of_value(value)
    CASH.each { |cash| break cash[:name] if cash[:value] == value }
  end

  def prepare_change(difference)
    diff = difference
    return {} if diff.zero?

    user_charge = {}

    descending_cash.each do |cash|
      counter = diff / cash[:value]
      next if counter.zero?

      stock                    = eval "@#{cash[:name]}"
      change_cash              = stock >= counter ? counter : stock
      user_charge[cash[:name]] = change_cash
      diff                     -= (change_cash * cash[:value])
    end

    raise NoChargeError, 'お釣りが足りません' unless diff.zero?

    user_charge
  end

  def initialized_user_payments
    user_payments = {}
    CASH.each { |cash| user_payments[cash[:name]] = 0 }
    user_payments
  end

  def descending_cash
    CASH.sort { |cash_a, cash_b| cash_b[:value] <=> cash_a[:value] }
  end
end
