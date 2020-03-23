Dir['./presenters/*.rb'].each { |file| require_relative file }

coke               = { id: 1, name: 'コーラ', price: 120, stock: 5, random_flag: true }
red_bull           = { id: 2, name: 'レッドブル', price: 200, stock: 5, random_flag: false }
water              = { id: 3, name: '水', price: 100, stock: 5, random_flag: false }
healthy_coke       = { id: 4, name: 'ダイエットコーラ', price: 120, stock: 5, random_flag: true }
tea                = { id: 5, name: 'お茶', price: 120, stock: 5, random_flag: true }
all_item_list      = [coke, red_bull, water, healthy_coke, tea]
initial_cash_stock = {
  ten_yen_coin:          10,
  fifty_yen_coin:        10,
  hundred_yen_coin:      10,
  five_hundred_yen_coin: 10,
  thousand_yen_bill:     10
}

item_list_presenter     = ItemListPresenter.new(all_item_list)
cash_box_presenter      = CashBoxPresenter.new(initial_cash_stock)

puts item_list_presenter.display_all

loop do
  input                     = gets.chomp
  input_judgement_presenter = InputJudgementPresenter.new(input)
  budget                    = cash_box_presenter.get_user_payments_sum
  buyable_list              = item_list_presenter.get_buyable(budget)

  if input_judgement_presenter.refund?
    puts cash_box_presenter.display_refund
    break
  elsif input_judgement_presenter.profit_check?
    puts cash_box_presenter.display_profit_check
    next
  elsif input_judgement_presenter.money?
    cash_box_presenter.add_user_payment!(input)
    budget = cash_box_presenter.get_user_payments_sum

    puts cash_box_presenter.display_user_payments_sum
    puts item_list_presenter.display_buyable(budget)
  elsif input_judgement_presenter.buy?(buyable_list)
    item_id = input_judgement_presenter.random? ? item_list_presenter.get_random_buyable_item_id(budget) : input.to_i
    price   = item_list_presenter.get_item_price_by_id(item_id)

    if cash_box_presenter.user_buy!(price)
      item_list_presenter.bought_item_by_id!(item_id)
      puts '購入しました！'
    else
      puts '購入できませんでした。'
    end

    budget = cash_box_presenter.get_user_payments_sum

    puts item_list_presenter.display_buyable(budget)
    puts cash_box_presenter.display_user_payments_sum
  else
    puts 'エラー'
    puts cash_box_presenter.display_refund
    break
  end
end
