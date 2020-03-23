class InputJudgementPresenter
  WHITE_LIST = ['10円玉', '50円玉', '100円玉', '500円玉', '1000円札'].freeze

  def initialize(input)
    @input = input
  end

  def buy?(buyable_list)
    random? ? random_buyable_item_exist?(buyable_list) : buyable_item_id?(buyable_list)
  end

  def refund?
    @input.empty? || @input == '払い戻し'
  end

  def profit_check?
    @input == '売上確認'
  end

  def money?
    WHITE_LIST.include?(@input)
  end

  def random?
    @input == 'ランダム'
  end

  private

  def random_buyable_item_exist?(buyable_list)
    buyable_list.count(&:random_flag).positive?
  end

  def buyable_item_id?(buyable_list)
    buyable_list.map(&:id).include?(@input.to_i)
  end
end
