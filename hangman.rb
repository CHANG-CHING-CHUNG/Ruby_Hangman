class Hangman
  @@word_list;
  @@guess_counter = 5;
  @@secret_word;
  @@full_secret_word= [];
  @@correct_letters = [];
  @@incorrect_letters = [];
  @@random_num;
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
    puts @@secret_word.inspect;
    puts @@full_secret_word.inspect;
  end

  def getUserInput
    puts "Guess a letter"
    inputLength = 0;
    userInput = 'a';
    begin
      if inputLength > 1 || !userInput.match(/[a-z]/)
        puts "One letter at a time!";
        puts "Please enter your letter again.";
      end
      userInput = gets.chomp.downcase;
      inputLength = userInput.length;
    end while inputLength != 1 || !userInput.match(/[a-z]/);
    puts userInput;
  end
end

a = Hangman.new;
a.createSecretWord();
a.getUserInput();