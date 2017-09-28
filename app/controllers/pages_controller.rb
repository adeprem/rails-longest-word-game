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
      @info ="Your word was not present in the English Dicitonnary"
    end
  else
    @score = 0
    @info = "You used at least one letter that was not part of the grid"
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
