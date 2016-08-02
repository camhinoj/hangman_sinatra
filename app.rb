require 'sinatra'
#require 'sinatra/reloader'
require_relative 'lib/Hangman.rb'

game = Hangman.new
FileUtils.rm_rf(Dir.glob('saves/*'))

get '/' do
	erb :index
end

get '/game' do
	game.new_word if game.word == []
	if params[:final_guess] != nil
		redirect to('/final_guess')
	end
	if params[:player_input] == nil
		message = ""
	elsif params[:player_input].size > 1 || !(letter?(params[:player_input]))
		message = "Please put a single letter"
	else
		message = ""
		game.guess(params[:player_input])		
	end
	erb :gameplay, :locals => {:game => game, :message => message}
end

get '/reset' do
	game.new_word
	redirect to('/game')
end

get '/save' do
	game.save_game
	redirect to('/')
end

get '/load_page' do
	erb :load
end

get '/load' do
	game.load_game(params[:save])
	redirect to('/game')
end

get '/final_guess' do
	if params[:final_guess] == nil
		win = ""
	elsif params[:final_guess] == game.word.join('')
		win = true
	else
		win = false
	end
	erb :final_guess, :locals => {:win => win, :game => game}
end

def letter?(input)
	input =~ /[[:alpha:]]/
end
