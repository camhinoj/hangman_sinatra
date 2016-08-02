class Hangman

	attr_reader :word

	def initialize
		@dictionary = File.readlines("5desk.txt").map { |word| word.strip.downcase }
		@start_time = Time.now.to_i
		@guesses = 0
		@word = []
		@completed_string = []
		@bad_letters = []
		play
	end

	def play
		puts "Load Game(Y/N)?"
		load = gets.chomp.downcase
		if load == "y"
			load_game
		else
			new_game
		end
		play_again
	end

	def play_again
		puts "would you like to play another game? (Y/N)"
		answer = gets.chomp.downcase
		initialize if answer == "y"
	end

	def player_input
		puts "Guess/Save"
		input = gets.chomp.downcase
		if input == "save"
			save_game
		else
			guess(input)
		end
	end

	def new_word
		sample = @dictionary.sample
		while sample.size > 12 || sample.size < 5
			sample = @dictionary.sample
		end
		@word = sample.split('')
		sample.size.times do
			@completed_string << "-"
		end
	end

	def guess(input)
		@guesses += 1
		if @word.include?(input)
			@word.each_with_index do |letter, index|
				@completed_string[index] = input if letter == input
			end
		else
			@bad_letters << input
		end
	end

	def new_game
		puts "What is your name"
		@player = gets.chomp
		new_word
		while @guesses <= 6
			puts @completed_string.join('')
			puts "You have #{6-@guesses} guesses left"
			puts "Used Letters: #{@bad_letters.join(" ")}"
			player_input
			if @completed_string == @word
				puts "You have won player"
				puts @completed_string.join('')
				return true
			end
		end
		puts "You have lost"
		puts "The correct word was #{@word.join('')}"
		return false
	end

	def save_game
		Dir.mkdir("saves") unless Dir.exists? "saves"
		save_state = [@player,@guesses,@word.join(''),@completed_string.join(''),@bad_letters.join(' '),@start_time].join(',')
		File.open("saves/player_#{@player}_#{@start_time}.txt", 'w') do |f|
			f.puts save_state
		end
		initialize
	end

	def load_game
		save_state = []
		puts "Choose one of these files"
		puts Dir.entries("saves").join(' ')
		file = "saves/" + gets.chomp
		save_state = File.new(file).readlines(sep=",")
		@player = save_state[0]
		@guesses = save_state[1].to_i
		@word = save_state[2].split('')
		@completed_string = save_state[3].split('')
		@bad_leters = save_state[4].split(' ')
		@start_time.to_i
		while @guesses <= 6
			puts @completed_string.join('')
			puts "You have #{6-@guesses} guesses left"
			puts "Used Letters: #{@bad_letters.join(" ")}"
			player_input
			if @completed_string == @word
				puts "You have won player"
				puts @completed_string.join('')
				return true
			end
		end
		puts "You have lost"
		puts "The correct word was #{@word.join('')}"
		return false
	end
end

cam = Hangman.new


