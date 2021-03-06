require 'json';

class Hangman
  @@word_list;
  @@guess_counter = 5;
  @@secret_word;
  @@full_secret_word= [];
  @@correct_letters = [];
  @@incorrect_letters = [];
  @@chosen_letters = [];
  @@letter_position = [];
  @@random_num;
  @@userInput;
  @@isLoad = false;
  @@isAsking = false;
  @@gameOver = false;

  protected
  def initialize()
    file = File.open("5desk.txt");
    newfile = file.readlines.map(&:chomp);
    @@word_list = newfile.select {|str| str.length > 5 && str.length < 12};
    # puts @@word_list.inspect;
    file.close;
  end

  def generate3randomNum(length)
    random = (0..length - 1).to_a.shuffle;
    @@random_num = random[0..2];
  end

  def generateRandomWord
    length = @@word_list.length;
    randomNum = (0..length - 1).to_a.shuffle;
    randomNum = randomNum.pop;
    word = @@word_list[randomNum].split("");
    @@secret_word = word;
  end
 
  def createSecretWord
    length = self.generateRandomWord().length;
    self.generate3randomNum(length);
    @@secret_word.each {
      |char|
      @@full_secret_word.push(char);
    }
    @@random_num.each_with_index {
      |num, i|
      @@secret_word[num] = '_';
    }
    puts 'Secret',@@secret_word.inspect;
  end

  def getUserInput
    puts "Guess a letter"
    inputLength = 0;
    @@userInput = gets.chomp.downcase;
    inputLength = @@userInput.length;
    while inputLength != 1 || !@@userInput.match(/[a-z]/) || self.checkChosenLetter();
      if inputLength != 1
        puts inputLength;
        puts "One letter at a time!";
        puts "Please enter your letter again.";
      elsif !@@userInput.match(/[a-z]/)
        puts inputLength;
        puts "Enter A-Z letters only.";
        puts "Please enter your letter again.";
      elsif self.checkChosenLetter()
        puts "The #{@@userInput} has been chosen before";
        puts "Please choose other letters";
      end
      @@userInput = gets.chomp.downcase;
      inputLength = @@userInput.length;
    end
    @@guess_counter = @@guess_counter - 1;
    puts @@userInput;
  end

  def checkUserInput
    isCorrect = false;
    @@letter_position.each_with_index {
      |pos, i|
      if @@full_secret_word[pos].downcase === @@userInput
        @@secret_word[pos] = @@userInput;
        isCorrect = true;
      end
    }

    if isCorrect
      @@correct_letters.push(@@userInput);
    else 
      @@incorrect_letters.push(@@userInput);
    end
    @@chosen_letters.push(@@userInput);
    
  end

  def displayStas
    puts 'Secret',@@secret_word.inspect;
    puts 'Counter',@@guess_counter.inspect;
    puts 'Correct',@@correct_letters.inspect;
    puts 'Incorrect',@@incorrect_letters.inspect;
  end

  def checkChosenLetter
    if @@chosen_letters.include?(@@userInput)
      return true;
    end
    return false;
  end

  def getLetterPosition
    @@secret_word.each_with_index {
      |letter, i|
      if letter === "_"
        @@letter_position.push(i);
      end
    }
  end

  def checkWin()
    win = true;
    @@secret_word.each_with_index {
      |char, i|
      if @@secret_word[i] != @@full_secret_word[i]
        win = false;
      end
    }
    if @@guess_counter === 0
      puts "Game Over";
      puts "Would you like to play next round? Y/N";
      begin
        case (continue = gets.chomp.downcase)
        when "y"
          return true;
        when "n"
          puts "Good Bye!";
          @@gameOver = true;
          return false;
        else 
          puts "Y or N only."
        end
      end while continue != "y" || continue != "n";
    elsif win
      puts "You win!";
      puts "Play again? Y/N";
      begin
        case (continue = gets.chomp.downcase)
        when "y"
          return true;
        when "n"
          puts "Good Bye!";
          return false;
        else 
          puts "Y or N only."
        end
      end while continue != "y" || continue != "n";
    else 
      return win
    end
  end

  def clearAll
    @@word_list;
    @@guess_counter = 5;
    @@secret_word;
    @@full_secret_word= [];
    @@correct_letters = [];
    @@incorrect_letters = [];
    @@chosen_letters = [];
    @@letter_position = [];
    @@random_num;
    @@userInput;
    @@isLoad = false;
  end

  
  def saveGame
    puts "If you want to save the game and quit, enter 'Y', else enter 'N' ";
    
    begin
      isYes = gets.chomp.downcase;
      case (isYes)
      when "y"
        self.to_JSON_file();
        return true
      when "n"
        return false;
      else
        puts "Y or N only.";
      end
    end while isYes != "y" || isYes != "n";
  end
  
  def to_JSON_file
    data = JSON.dump ({
      :guess_counter => @@guess_counter,
      :secret_word => @@secret_word,
      :full_secret_word => @@full_secret_word,
      :correct_letters => @@correct_letters,
      :incorrect_letters => @@incorrect_letters,
      :chosen_letters => @@chosen_letters,
      :letter_position => @@letter_position,
    })
    
    newFile = File.open("save.json", "w") {
      |f|
      f.write(data);
    }
  end

  def loadStatusFromJSON()
    gameStatus = JSON.load File.read("save.json");
    @@guess_counter =  gameStatus["guess_counter"];
    @@secret_word = gameStatus["secret_word"];
    @@full_secret_word = gameStatus["full_secret_word"];
    @@correct_letters = gameStatus["correct_letters"];
    @@incorrect_letters = gameStatus["incorrect_letters"];
    @@chosen_letters = gameStatus["chosen_letters"];
    @@letter_position = gameStatus["letter_position"];
  end
  
  def askLoading
    puts "Load the game that you saved last time? Y/N";
    begin
      ans = gets.chomp.downcase;
      case (ans)
      when 'y'
        @@isLoad = true;
        return @@isLoad
      when 'n'
        @@isLoad = false;
        return @@isLoad
      end
    end while ans != 'y' || ans != 'n'
  end

  public
  def gameStart
    gameOver = false
    if !@@isAsking
      self.askLoading()
      @@isAsking = true;
    end
    if @@isLoad
      self.loadStatusFromJSON();
      self.displayStas();
    else
      self.createSecretWord();
      self.getLetterPosition();
    end
    begin
      if self.saveGame()
        puts "See you~!";
        win = true;
        break
      end
      self.getUserInput();
      self.checkUserInput();
      self.displayStas();
      win = self.checkWin();
      if win
        self.clearAll();
        self.gameStart();
      end
    end while !win && @@gameOver === false;
  end
end

hangman = Hangman.new;
hangman.gameStart();