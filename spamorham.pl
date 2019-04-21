$train = "train.csv"; # default train file
$test = "test.csv"; # default test file
if ($# ARGV > 0) { $train = $ARGV[0]; } # override if argument
if ($# ARGV > 0){  $test  = $ARGV[1]; } # override if argument

my $n_msgs = 0; # count of all messages
my $n_spam = 0; # count of spam messages
my $n_ham = 0;  # count of ham messages
my %counts;     # empty map, stores counts indexed by label/word pair

# open the file $train and iterate it with file handler $in
open my $in, $train or die "$train: $!"; 
while (my $line = <$in>) {
  chomp $line;                          # yum yum
  my @fields = split "," , $line;       # split line by comma
  my $label = $fields[0];               # this is the label: spam or ham (string)
  my $msg = $fields[1];                 # this is the text message (string)

  # update the ham , spam , and total message counts

  # loop over each (lower -case) word
  foreach $word (split /\s+/, lc($msg)) {
    # update count for that word / label pair
  }
}

# close the file handler
close $in;

use List::Util 'sum'; # needed library for sum function below

# Count the number of unique words for ‘‘ham’’
my $n_unq_words_ham = keys %{$counts{"ham"}}; # ACTION: find count of unique spam words
# Count the sum of the counts of all ham words
my $n_words_ham = sum values %{$counts{"ham"}}; # ACTION: find sum of counts of all spam words
# ACTION: find total counts of spam words plus ham words

