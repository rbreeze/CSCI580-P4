####################
# CSCI580 Spring 2019 Project 4 
# spamorham.pl
# Remington Breeze  
####################

$train = "train.csv"; # default train file
$test = "test.csv"; # default test file
if ($# ARGV > 0) { $train = $ARGV[0]; } # override if argument
if ($# ARGV > 0){  $test  = $ARGV[1]; } # override if argument

my $n_msgs = 0;  # count of all messages
my $n_spam = 0;  # count of spam messages
my $n_ham = 0;   # count of ham messages
my $correct = 0; # count of correct classifications
my %counts;      # empty map, stores counts indexed by label/word pair

# open the file $train and iterate it with file handler $in
open my $in, $train or die "$train: $!"; 
while (my $line = <$in>) {
  chomp $line;                          # yum yum
  my @fields = split "," , $line;       # split line by comma
  my $label = $fields[0];               # this is the label: spam or ham (string)
  my $msg = $fields[1];                 # this is the text message (string)

  # update the ham , spam , and total message counts
  if ($label == "ham") $n_ham++; 
  else if ($label == "spam") $n_spam++; 
  $n_msgs++; 

  # loop over each (lower-case) word
  foreach $word (split /\s+/, lc($msg)) {
    # update count for that word / label pair
    %counts{$word}{$label}++; 
  }
}

# close the file handler
close $in;

use List::Util 'sum'; # needed library for sum function below

# Count the number of unique words for "ham"
my $n_unq_words_ham = keys %{$counts{"ham"}}; 
# Count the number of unique words for "spam"
my $n_unq_words_spam = keys %{$counts{"spam"}};

# Count the sum of the counts of all ham words
my $n_words_ham = sum values %{$counts{"ham"}}; 
# Count the sum of the counts of all spam words
my $n_words_spam = sum values %{$counts{"spam"}}; 

# find total counts of spam words plus ham words
my $n_total_words = $n_words_ham + $n_words_ham;

# a priori ham / spam probabilities
my $prior_spam = log ( $n_spam / $n_msgs );
my $prior_ham = log ( $n_ham / $n_msgs );

# Loop through the test file
# For each message, predict spam or ham 
# Calculate overall accuracy

# open the file $train and iterate it with file handler $in
open my $test_in, $test or die "$test: $!"; 
while (my $line = <$test_in>) {
  chomp $line;                          # yum yum
  my @fields = split "," , $line;       # split line by comma
  my $label = $fields[0];               # this is the label: spam or ham (string)
  my $msg = $fields[1];                 # this is the text message (string)

  my $p_ham = log($prior_ham);
  my $p_spam = log($prior_spam);

  # loop over each (lower-case) word
  foreach $word (split /\s+/, lc($msg)) {
    $p_ham += log( %counts{$word}{"ham"} / $n_words_ham )
    $p_spam += log( %counts{$word}{"spam"} / $n_words_spam )
  }

  $prediction = $p_ham > $p_spam ? "ham" : "spam"; 

  printf("$label, $prediction, %.5f, %.5f", $p_ham, $p_spam);

  if ($prediction == $label) $correct++; 

}

printf("Accuracy = %.2f\n", ($correct/$n_msgs));

