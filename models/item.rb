require_relative '../errors/item_errors'

class Item
  attr_reader :id, :name, :price, :stock, :random_flag

  def initialize(args_hash)
    @id          = args_hash[:id]
    @name        = args_hash[:name]
    @price       = args_hash[:price]
    @stock       = args_hash[:stock]
    @random_flag = args_hash[:random_flag]
  end

  def buyable?(budget)
    in_stock? && within_budget?(budget)
  end

  def bought!
    raise NoStockError if out_stock?

    @stock -= 1
  end

  private

  def in_stock?
    @stock.positive?
  end

  def out_stock?
    !in_stock?
  end

  def within_budget?(budget)
    @price <= budget
  end
end
