# frozen_string_literal: true

class Card
  SUITS = %w[♠ ♣ ♥ ♦].freeze
  NUMBERS = (2..10).to_a
  PICTURES = %w[J Q K A].freeze

  attr_reader :suit, :value, :rank

  def initialize(suit, value, rank)
    @rank = rank
    @suit = suit
    @value = value
  end

  def to_s
    "#{rank}#{suit}"
  end
end
