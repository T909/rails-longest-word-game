require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    generate(@letters)
  end

  def play
    @score = params[:score]
    @letters = []
    generate(@letters)
  end

  def score
    @score = params[:score].present? ? params[:score].to_i : 0
    @answer = params[:answer]
    @grid = params[:grid].split(" ")

    if get_api(@answer) == false
      @message = "Sorry but #{@answer} does not seem to be a valid english word"
    elsif (grid_included?(@answer, @grid) == false)
      @message = "Sorry but #{@answer} can't be built out of #{@grid.join(", ")}"
    else
      @score += @answer.size
      @message = "Congratualtions #{@answer} is a valid english word. Your score is #{@score}"
      params[:score] = @score
    end
  end

  private
  def generate(array)
    10.times.each do
      array << ("A".."Z").to_a[rand(0..25)]
    end
  end

  def get_api(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    api_answer = open(url).read
    JSON.parse(api_answer)["found"]
  end

  def grid_included?(attempt, grid)
    attempt.upcase.chars.all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
  end
end
