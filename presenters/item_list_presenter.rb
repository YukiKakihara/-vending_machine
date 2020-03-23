require_relative '../models/item'

class ItemListPresenter
  def initialize(item_list)
    @items = item_list.map { |item| Item.new(item) }
  end

  def bought_item_by_id!(id)
    @items.select { |item| item.id == id }.first&.bought!
  end

  def get_buyable(budget)
    @items.select { |item| item.buyable?(budget) }
  end

  def get_item_price_by_id(id)
    @items.select { |item| item.id == id }.first&.price
  end

  def get_random_buyable_item_id(budget)
    @items.select { |item| item.random_flag && item.buyable?(budget) }.sample.id
  end

  def display_all
    @items.inject("【商品リスト】\n") { |list, item| add_detail(list, item) }
  end

  def display_buyable(budget)
    item_list = "【購入可能な商品】\n"
    buyable_items = @items.select { |item| item.buyable?(budget) }
    return item_list + '存在しません' if buyable_items.empty?

    buyable_items.inject(item_list) { |list, item| add_detail(list, item) }
  end

  private

  def add_detail(list, item)
    list += "--------------------\n"
    list += "・ID：#{item.id}\n・名前：#{item.name}\n・値段：#{item.price}円\n・在庫：#{item.stock}個\n"
    list += "--------------------\n"
  end
end
