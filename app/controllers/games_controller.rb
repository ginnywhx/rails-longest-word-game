require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times do
      @grid << ("a".."z").to_a.sample
    end
  end


  def score
    @grid = params[:hidden]
    @attempt = params[:word]
    session[:score] = session[:score] || 0

    buffer = open("https://wagon-dictionary.herokuapp.com/#{@attempt}")
    exists = JSON.parse(buffer.read)

    if exists["found"] && check_is_in_grid(@attempt,@grid) && letter_amount(@attempt,@grid)
      @result = "Well done. Your word is english"
      @score = @attempt.length
      session[:score] += @score
    elsif exists["found"]
      @result= "Not in the grid"
    else
      @result = "Not an english word"
    end
  end

  def check_is_in_grid(attempt, grid)
    attempt.chars.all? { |letter| grid.include?(letter) }
  end

  def letter_amount(attempt, grid)
    attempt.chars.all? do |letter|
    attempt.count(letter) <= grid.count(letter)
    end
  end
end
