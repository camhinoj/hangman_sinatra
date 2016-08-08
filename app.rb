require 'sinatra'
#require 'sinatra/reloader' if development?
require_relative 'lib/Hangman.rb'
enable :sessions

set :session_secret, 'super secret'

FileUtils.rm_rf(Dir.glob('saves/*'))

get '/' do
	erb :index
end

get '/game' do
	game = Hangman.new
	load_state game
	if params[:final_guess] != nil
		redirect to('/final_guess')
	end
	if params[:player_input] == nil
		message = ""
	elsif params[:player_input].size > 1 || !(letter?(params[:player_input]))
		message = "Please put a single letter"
	else
		message = ""
		game.guess(params[:player_input].downcase)
		save_state(game)
	end
	erb :gameplay, :locals => {:game => game, :message => message}
end

get '/reset' do
	game = Hangman.new
	game.new_word
	save_state(game)
	redirect to('/game')
end

# get '/save' do
# 	game.save_game
# 	redirect to('/')
# end

# get '/load_page' do
# 	erb :load
# end

# get '/load' do
# 	game.load_game(params[:save])
# 	redirect to('/game')
# end

get '/final_guess' do
	game = Hangman.new
	load_state(game)
	if params[:final_guess] == nil
		win = ""
	elsif params[:final_guess].downcase == game.word.join('')
		win = true
	else
		win = false
	end
	erb :final_guess, :locals => {:win => win, :game => game}
end

# get '/win' do
# 	erb :final_guess, :locals => {:win => true, :game => game}
# end

def save_state(game)
	session['word'] = game.word.join('')
	session['cstring'] = game.completed_string.join('')
	session['guesses'] = game.guesses
	session['bad'] = game.bad_letters.join('')
end

def load_state(game)
	game.word = session[:word].split('')
	game.completed_string = session[:cstring].split('')
	game.guesses = session[:guesses]
	game.bad_letters = session[:bad].split('')
end

def letter?(input)
	input =~ /[[:alpha:]]/
end
