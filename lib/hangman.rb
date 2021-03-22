# frozen_string_literal: true

require_relative 'save_load'
require 'yaml'

# A simple program to run the hangman game
class Hangman
  include SaveLoad
  def initialize
    word_list = File.readlines('5desk.txt')
    @secret_word = word_list.sample.chomp.downcase
    @lives = 7 # Head, body, 2 arms, 2 legs, and final miss
    @word_teaser = ""
    @secret_word.length.times do
      @word_teaser += '_ '
    @guess = nil
    end
  end

  # Before starting the game, this prompts if the user would like to load their save_game.yml
  def load_prompt
    puts 'Do you want to load a saved game? (yes/no)'
    answer = gets.chomp
    if answer == 'yes'
      load_game
    else
      puts "Enter 'save' to save the game between turns"
      round_start
    end
  end


  # Starts the game, shows the length of the word
  def round_start
    puts 'Welcome to Hangman!'
    puts "The word is #{@secret_word.length} characters long."
    print_teaser
    player_guess
  end

  # Prints the teaser. _ _ _ _
  def print_teaser(last_guess = nil)
    update_teaser(last_guess) unless last_guess.nil?
    puts @word_teaser
  end

  # Updates the teaser to include a correct letter T _ S T
  def update_teaser(last_guess)
    new_teaser = @word_teaser.split

    new_teaser.each_with_index do |letter, index|
      if letter == '_' && @secret_word[index] == last_guess
        new_teaser[index] = last_guess
      end
    end

    @word_teaser = new_teaser.join(' ')
  end

  # Comparing if the guess is correct and updating teaser, or incorrect and deducting a life
  def guess_compare(guess)
    # Defining correct_guess as a guess where the letter is properly included
    correct_guess = @secret_word.include? guess
    if correct_guess == true
      puts "The letter #{guess} is correct! Good job!"
      print_teaser guess
    else
      @lives -= 1
      puts "The letter #{guess} is incorrect!"
      puts "The hangman has #{@lives} lives left!"
    end
    player_guess
  end

  # Takes player guess
  def player_guess
    # Checking to see if player solved the word
    if @secret_word == @word_teaser.split.join
      puts 'Congratulations! You win!'
  # Comparing if lives remain
    elsif @lives.positive?
      puts 'Please guess a letter from A to Z'
      @guess = gets.chomp.downcase
      # Making sure the input is a single character from A through Z
      if @guess == 'save'
        define_game_state
      elsif @guess.chars.all? { |c| ('a'..'z').include?(c) } && @guess.length == 1
        guess_compare(@guess)
      else
        puts 'Invalid guess, please guess a letter from A to Z'
        player_guess
      end
    else
      puts "You are out of lives! The word was #{@secret_word}."
      puts 'Better luck next time!'
    end
  end
end
