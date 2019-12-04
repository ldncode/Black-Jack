# frozen_string_literal: true

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    generate_cards
  end

  def deal!
    @cards.shift
  end

  def shuffle
    generate_cards
  end

  private

  def generate_cards
    Card::SUITS.each do |suit|
      Card::NUMBERS.each do |rank|
        @cards << Card.new(rank, suit, rank)
      end
      Card::PICTURES.each do |rank|
        value = rank == 'A' ? [1, 11] : 10
        cards << Card.new(rank, suit, value)
      end
    end
    @cards.shuffle
  end
end
