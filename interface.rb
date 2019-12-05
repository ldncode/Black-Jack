# frozen_string_literal: true

class Interface
  PLAYER_CHOICE = [
      { title: 'Пропустить', answer: 1, action: :skip },
      { title: 'Добавить карту', answer: 2, action: :take },
      { title: 'Открыть карты', answer: 3, action: :open }
  ].freeze

  def start_game
    puts 'Добро пожаловать в Блэк Джек'
  end

  def user_name
    puts 'Введите имя '
    gets.chomp
  end

  def show_bets(players, amount, bank)
    print_separator
    players.each { |player| puts "Ставка игрока - #{player.name}: #{amount}" }
    puts "Игровой банк равен: #{bank}$"
  end

  def show_hands(players, mode = nil)
    print_separator

    players.each_with_index do |player, index|
      print_separator('-', 20) if index.positive?

      puts "#{player.name} (#{player.bank}$):"

      show_hand(player, mode)
    end
  end

  def show_hand(player, mode)
    player_hand = player.hand

    if mode == :open || !player.is_a?(Dealer)
      puts player_hand.cards.join(' + ') + "Количество очков: #{player_hand.value}"
    else
      player_hand.cards.length.times do |count|
        print count.positive? ? ' + **' : '**'
      end
    end
  end

  def show_banks(players)
    players.each { |player| puts "Банк игрока - #{player.name}: #{player.bank}" }
  end

  def show_winner(winner)
    print_separator

    if winner.nil?
      puts 'Ничья'
    else
      puts "Победил игрок - #{winner.name}"
    end
  end

  def player_choice
    print_separator

    loop do
      PLAYER_CHOICE.each do |choice|
        puts "#{choice[:answer]} - #{choice[:title]}"
      end

      answer = select_answer
      selected = PLAYER_CHOICE.find { |item| answer == item[:answer] }

      next unless selected

      return selected[:action]
    end
  end

  def select_answer
    print 'Выбери действие '
    gets.to_i
  end

  def print_skip_turn(player)
    print_separator
    puts "#{player.name} пропустил ход"
  end

  def print_take_card(player)
    print_separator
    puts "#{player.name} взял карту"
  end

  def restart_game?
    loop do
      print_separator
      print 'Хочешь поиграть еще? One more game? (Да/Нет): '
      answer = gets.chomp

      return true if ['', 'Да', 'да'].include?(answer)
      return false if %w[Нет нет].include?(answer)
    end
  end

  def print_separator(mark = '-', length = 40)
    length.times do
      puts mark
    end
  end
end
