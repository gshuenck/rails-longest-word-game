require 'net/http'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = ('A'..'Z').to_a.sample(10).join(' ')
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(' ')
    @message = check
  end

  private

  def check
    url = URI("https://dictionary.lewagon.com/#{@word}")
    response = Net::HTTP.get(url)
    result = JSON.parse(response) rescue nil

    if result && result['found']
      if can_build_word?(@word, @letters)
        "Congratulations! #{@word} is a valid English word"
      else
        "Sorry but #{@word} can't be built out of #{@letters.join(' ')}"
      end
    else
      "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end

  def can_build_word?(word, letters)
    word_hash = word.chars.tally
    letters_hash = letters.tally

    # Ensure all characters in the word are present in the letters_hash
    word_hash.all? { |char, count| letters_hash.fetch(char, 0) >= count }
  end
end
