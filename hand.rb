# frozen_string_literal: true

class Hand
  attr_reader :cards, :value

  def initialize
    drop
  end

  def drop
    @cards = []
    @value = 0
  end

  def take_cards(deck, amount = 1)
    amount.times { @cards << deck.deal! }

    sum_value
  end

  def sum_value
    value = 0

    @cards.each do |card|

      value += card.value unless card.value.is_a?(Array)
    end

    @cards.each do |card|
      next unless card.value.is_a?(Array)

      value += value_for_ace(value, card.value)
    end

    @value = value
  end

  def value_for_ace(value, ace_value)
    if value + ace_value.last > 21
      ace_value.first
    else
      ace_value.last
    end
  end
end
