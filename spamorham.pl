####################
# CSCI580 Spring 2019 Project 4 
# spamorham.pl
# Remington Breeze  
####################

$train = "train.csv"; # default train file
$test = "test.csv"; # default test file
if ($#ARGV > 0) { $train = $ARGV[0]; } # override if argument
if ($#ARGV > 0){  $test  = $ARGV[1]; } # override if argument

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
  if ($label eq "ham") { $n_ham++; }
  elsif ($label eq "spam") { $n_spam++; }
  $n_msgs++; 

  # loop over each (lower-case) word
  foreach $word (split /\s+/, lc($msg)) {
    # update count for that word / label pair
    $counts{$label}{$word}++; 
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

# reset message count 
$n_msgs = 0; 

# open the file $train and iterate it with file handler $in
open my $test_in, $test or die "$test: $!"; 
while (my $line = <$test_in>) {
  chomp $line;                          # yum yum
  my @fields = split "," , $line;       # split line by comma
  my $label = $fields[0];               # this is the label: spam or ham (string)
  my $msg = $fields[1];                 # this is the text message (string)

  my $p_ham = $prior_ham;
  my $p_spam = $prior_spam;

  $n_msgs++; 

  # loop over each (lower-case) word
  foreach $word (split /\s+/, lc($msg)) {
    $min = log ( 1 / ($n_total_words) ); 
    $p_ham += $counts{"ham"}{$word} > 0 ? log( $counts{"ham"}{$word} / $n_words_ham ) : $min;
    $p_spam += $counts{"spam"}{$word} > 0 ? log( $counts{"spam"}{$word} / $n_words_spam ) : $min;
  }

  $prediction = $p_ham > $p_spam ? "ham" : "spam"; 

  printf("$label, $prediction, %.5f, %.5f\n", $p_ham, $p_spam);

  if ($prediction eq $label) { $correct++; }

}

# Calculate overall accuracy
printf("Accuracy = %.2f\n", ($correct/$n_msgs));

