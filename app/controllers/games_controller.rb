require 'open-uri'
require 'json'

class GamesController < ApplicationController

    def new
        # @letters = []
        # 10.times do
        #     @letters << ('A'..'Z').to_a.sample
        # end
        @letters = ('A'..'Z').to_a.sample(8)
        2.times do
          @letters << ['A', 'E', 'I', 'O', 'U', 'Y'].sample
        end

    end


    def score
        @score = ""
        @word = params[:word]
        word_url = 'https://wagon-dictionary.herokuapp.com/' + @word

        word_serialized = open(word_url).read
        @api_result = JSON.parse(word_serialized)


        # @word_in_array = @word.chars
        @my_word = @word.upcase.chars.sort
        @the_grid = params[:grid].chars.sort

       @condition_grid = compare_grid_and_word(@the_grid, @my_word)
       @scoring = @api_result.length

        if @condition_grid && @api_result['found']
            @score = "is a good word (english and in the grid). Your score is #{@api_result['length']}. "
            @message = "Good Job,"
            @score = @api_result['length']
        elsif !@condition_grid && !@api_result['found']
            @score = "is not an english word and not in the grid"
            @message = "Sorry"
            @score = 0
        else
            @score ="is not in the grid"
            @message = "Sorry"
            @score = 0
        end

        session["score"] == nil ? session["score"] = @score : session["score"] += @score

        @session_score = session["score"]

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


      def start_new_session
        session.delete(:score)
        new_path
      end


end
