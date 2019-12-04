# frozen_string_literal: true

require_relative 'interface'
require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
require_relative 'card'

class BlackJack
  attr_reader :interface, :dealer, :player, :deck, :players

  def initialize(interface)
    @bank = 0
    @interface = interface
    @deck = Deck.new
  end

  def start
    interface.start_game
    init_players
    game
  end

  def init_players
    @player = Player.new(interface.user_name)
    @dealer = Dealer.new
    @players = [@player, @dealer]
  end

  def game
    loop do
      new_game
      player_choice

      break unless interface.restart_game?

      players.each { |player| break unless player.money? }
    end
  end

  def new_game
    deck.shuffle
    players.each do |player|
      player.hand.drop
      player.hand.take_cards(deck, 2)
    end
    bet(10)
    interface.show_hands(players)
  end

  def bet(amount)
    players.each { |player| player.bet(amount) }
    @bank = amount * 2
    interface.show_bets(players, amount, @bank)
  end

  def player_choice
    selected = interface.player_choice

    case selected
    when :skip
      dealer_choice
    when :take
      take_card
    when :open
      open_cards
    end
  end

  def take_card
    player.hand.take_cards(deck)
    interface.print_take_card(player)
    dealer_choice
  end

  def open_cards
    interface.show_hands(players, :open)
    sum_result(player.hand.value, dealer.hand.value)
    interface.show_banks(players)
    @bank = 0
  end

  def dealer_choice
    dealer_hand = dealer.hand

    if dealer_hand.value >= 17 || dealer_hand.cards.length > 2
      interface.print_skip_turn(dealer)
    else
      dealer_hand.take_cards(deck)
      interface.print_take_card(dealer)
    end

    choice_route
  end

  def choice_route
    if player.hand.cards.length > 2
      open_cards
    else
      interface.show_hands(players)

      player_choice
    end
  end

  def sum_result(player_value, dealer_value)
    if player_value > 21
      win(dealer)
    elsif dealer_value > 21 || player_value > dealer_value
      win(player)
    elsif player_value == dealer_value
      win(nil)
    else
      win(dealer)
    end
  end

  def win(winner)
    if winner.nil?
      half_bank = @bank / 2

      players.each { |player| player.win(half_bank) }
    else
      winner.win(@bank)
    end

    interface.show_winner(winner)
  end
end

BlackJack.new(Interface.new).start
