require 'open-uri'
require 'json'

class GamesController < ApplicationController

    def new
        @grid = []
        @letter = ""
        10.times do
            @grid << ('A'..'Z').to_a.sample
        end
    end
    

    def score
        @score = ""
        @word = params[:word]
        word_url = 'https://wagon-dictionary.herokuapp.com/' + @word

        word_serialized = open(word_url).read
        @word2 = JSON.parse(word_serialized)

        @word_in_array = @word.chars
        @my_word = @word.upcase.chars.sort
        @the_grid = params[:grid].chars.sort

       @condition_grid = compare_grid_and_word(@the_grid, @my_word)

        if @condition_grid && @word2['found']
                @score = "well done"
        elsif !@condition_grid && !@word2['found']
            @score = "is not an english word and not in the grid"
        else
            @score ="is not in the grid"
        end

    end


    def compare_grid_and_word(grid, attempt)
        grid_hash = Hash.new(0)
        grid.each { |letter| grid_hash[letter.downcase] += 1 }
      
        attempt_hash = Hash.new(0)
        attempt.each { |letter| attempt_hash[letter.downcase] += 1 }
      
        attempt_hash.each do |key, value|
          return false unless grid_hash.key?(key) && value <= grid_hash[key]
        end

        return true
      end


end
