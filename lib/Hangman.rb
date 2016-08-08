class Hangman

	attr_accessor :guesses, :word, :completed_string, :bad_letters

	def initialize
		@dictionary = File.readlines("assets/5desk.txt").map { |word| word.strip.downcase }
		@start_time = Time.now.to_i
		@guesses = 0
		@word = []
		@completed_string = []
		@bad_letters = []
	end

	def new_word
		@guesses = 0
		@completed_string = []
		@bad_letters = []
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
		input = input.downcase
		if @word.include?(input)
			@word.each_with_index do |letter, index|
				@completed_string[index] = input if letter == input
			end
		else
			@guesses += 1
			@bad_letters << input
		end
	end

	def save_game
		save_state = [@guesses,@word.join(''),@completed_string.join(''),@bad_letters.join(' '),@start_time].join(',')
		File.open("saves/time_#{@start_time}.txt", 'w') do |f|
			f.puts save_state
		end
	end

	def load_game(save)
		save_state = []
		file = "saves/" + save
		save_state = File.new(file).readlines(sep=",")
		@guesses = save_state[0].to_i
		@word = save_state[1].split('')
		@completed_string = save_state[2].split('')
		@bad_leters = save_state[3].split(' ')
		@start_time = save_state[4].to_i
	end
end