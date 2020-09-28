class Hangman
  @@word_list;
  @@guess_counter = 5;
  @@secret_word;
  @@full_secret_word= [];
  @@correct_letters = [];
  @@incorrect_letters = [];
  @@chosen_letters = [];
  @@random_num;
  @@userInput;
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
    puts 'Full word', @@full_secret_word.inspect;
  end

  def getUserInput
    puts "Guess a letter"
    inputLength = 0;
    @@userInput = 'a';
    begin
      if inputLength > 1 || !@@userInput.match(/[a-z]/)
        puts "One letter at a time!";
        puts "Please enter your letter again.";
      elsif self.checkChosenLetter()
        puts "The #{@@userInput} has been chosen before";
        puts "Please choose other letters";
      end
      @@userInput = gets.chomp.downcase;
      inputLength = @@userInput.length;
    end while inputLength != 1 || !@@userInput.match(/[a-z]/) || self.checkChosenLetter();
    @@guess_counter = @@guess_counter - 1;
    puts @@userInput;
  end

  def checkUserInput
    if @@full_secret_word.include?(@@userInput);
      @@full_secret_word.each_with_index {
        |char, i|
        if @@userInput === char
          @@secret_word[i] = @@userInput;
        end
      }
      @@correct_letters.push(@@userInput);
      @@chosen_letters.push(@@userInput);
    else
      @@incorrect_letters.push(@@userInput);
      @@chosen_letters.push(@@userInput);
    end
  end

  def displayStas
    puts 'Correct',@@correct_letters.inspect;
    puts 'Incorrect',@@incorrect_letters.inspect;
    puts 'Chosen',@@chosen_letters.inspect;
    puts 'Secret',@@secret_word.inspect;
    puts 'Counter',@@guess_counter.inspect;
  end

  def checkChosenLetter
    if @@chosen_letters.include?(@@userInput)
      return true;
    end
    return false;
  end
end

a = Hangman.new;
a.createSecretWord();
a.getUserInput();
a.checkUserInput();
a.displayStas();
a.getUserInput();
a.checkUserInput();
a.displayStas();