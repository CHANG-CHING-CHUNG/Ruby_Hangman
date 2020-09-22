class Hangman
  @@word_list;
  @@guess_counter = 5;
  def initialize()
    file = File.open("5desk.txt");
    newfile = file.readlines.map(&:chomp);
    @@word_list = newfile.select {|str| str.length > 5 && str.length < 12};
    # puts @@word_list.inspect;
    file.close;
  end

  def generate3randomNum
    random = (0..11).to_a.shuffle;
    threeNums = random[0..2];
    puts threeNums.inspect;
  end

  def generateRandomWord
    length = @@word_list.length;
    randomNum = (0..length - 1).to_a.shuffle;
    randomNum = randomNum.pop;
    word = @@word_list[randomNum];
    puts word;
  end
end

a = Hangman.new;
a.generateRandomWord();