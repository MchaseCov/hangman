require 'yaml'
  # This module controls the save and load for the hangman.rb file
module SaveLoad

  # Assigns the game state to variables before actually saving it to the YAML
  def define_game_state
    game_state = {
      'guess' => @guess,
      'secret_word' => @secret_word,
      'word_teaser' => @word_teaser,
      'lives' => @lives,
    }
    save_game(game_state)
  end
  # Takes the previously assigned state and writes it to the YAML file
  def save_game(game_state)
    save_file = File.open('save_game.yml', 'w')
    YAML.dump(game_state, save_file)
    save_file.close
    exit
  end
  # Loads the YAML file based on the same variables that were written to it!
  def load_game
    save_file = YAML.load(File.read('save_game.yml'))
    @guess = save_file['guess']
    @secret_word = save_file['secret_word']
    @word_teaser = save_file['word_teaser']
    @lives = save_file['lives']
    round_start
  end
end