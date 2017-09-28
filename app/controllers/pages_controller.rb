require 'open-uri'
require 'json'
require 'date'
require 'time'

class PagesController < ApplicationController
  def game
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    @start_time = Time.parse(params[:start])
    @end_time = Time.now
   @guess = params[:guess]
   grid = params[:grid]
   @grid = grid.split(//)
   if included?(@guess.upcase, @grid)
    if english_word?(@guess)
      score = compute_score(@guess, @start_time, @end_time)
      @score = score
      @info = "well done"
    else
      @score = 0
      @info ="not an english word"
    end
  else
    @score = 0
    @info = "not in the grid"
  end
end


def included?(guess, grid)
  guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
end

def compute_score(guess, start_time, end_time)
  time_taken = end_time - start_time
  time_taken > 120.0 ? 0 : (guess.size * 10) * (1.0 - time_taken / 60.0)
end

def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
end
end
# def run_game(guess, grid, start_time, end_time)
#   result = { time: end_time - start_time }

#   score_and_message = score_and_message(@guess, @grid, result[:time])
#   result[:score] = score_and_message.first
#   result[:message] = score_and_message.last

#   result
# end

# def score_and_message(@guess, @grid, time)
#   if included?(@guess.upcase, @grid)
#     if english_word?(@guess)
#       score = compute_score(@guess, time)
#       [score, "well done"]
#     else
#       [0, "not an english word"]
#     end
#   else
#     [0, "not in the @grid"]
#   end
# end

