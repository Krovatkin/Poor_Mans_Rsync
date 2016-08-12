#1.1. Accessing Substrings

substr($string, -12)  = "ondrous";# replace last 12 chars with "ondrous"
substr($string, -10)  = "";       # delete last 10 characters

substr($string, 0, 5) =~ s/is/at/g; # substitute "at" for "is" in first 5 chars

# exchange the first and last letters in a string
(substr($a,0,1), substr($a,-1)) = 
(substr($a,-1),  substr($a,0,1));

cut2fmt(8, 14, 20, 26, 30); #generates A7 A6 A6 A6 A4 A*

#1.2. Establishing a Default Value

$a = $b || $c; # use $b if $b is true, else $c
$x ||= $y; # set $x to $y unless $x is already true

$a = defined($b) ? $b : $c; # use $b if $b is defined, else $c

use v5.9; # the "new" defined-or operator from future perl
$a = $b // $c;

$dir = shift(@ARGV) || "/tmp"; #ARGV[0] is the first arg, $0 is the executable's name

# find the user name on Unix systems
$user = $ENV{USER}
     || $ENV{LOGNAME}
     || getlogin( )
     || (getpwuid($<))[0]
     || "Unknown uid number $<";
	 
#You can’t use or in place of || in assignments, because or’s precedence is too low. 
$a = $b or $c #equivalent to ($a = $b) or $c

@a = @b unless @a; # copy only if empty; value copy semantics for arrays

#1.3. Exchanging Values Without Using Temporary Variables
$alpha, $beta, $production) = qw(January March August);
($alpha, $beta, $production) = ($beta, $production, $alpha);

#1.4. Converting Between Characters and Values
$num  = ord($char);
$char = chr($num);

printf("Number %d is character %c\n", $num, $num);

printf "%vd\n", "fac\x{0327}ade"; #102.97.99.807.97.100.101
printf "%vx\n", "fac\x{0327}ade"; #66.61.63.327.61.64.65

@unicode_points = unpack("U*", "fac\x{0327}ade"); # 102 97 99 807 97 100 101
$word = pack("U*", @unicode_points); # façade

@byte = unpack("C*", "HAL"); #compress 
foreach $val (@byte) {
    $val++;                 # add one to each byte value
}
$ibm = pack("C*", @byte);
print "$ibm\n";             # prints "IBM"

#1.5. Using Named Unicode Characters
#You want to use Unicode names for fancy characters in your code without worrying about their code points.


#1.6. Processing a String One Character at a Time
@array = split(//, $string);      # each element a single character
@array = unpack("U*", $string);   # each element a code point (number)

%seen = (); $seen{$_}++ for ('an apple a day' =~ /(.)/g);
print "unique chars are: ", sort(keys %seen), "\n";

$sum = unpack("%32C*", $string); # %<number> to indicate that you want a <number>-bit checksum

#1.7. Reversing a String by Word or Character
$gnirts   = reverse($string);       # reverse letters in $string
@sdrow    = reverse(@words);        # reverse elements in @words
$confused = reverse(@words);        # reverse letters in join("", @words)

#causes split to use contiguous whitespace as the separator 
#and also discard leading null fields, just like awk
$revwords = join(" ", reverse split(" ", $string));

#1.8. Treating Unicode Combined Characters as Single Characters

$string = "fac\x{0327}ade";         # "façade"
@chars = $string =~ /(.)/g;         # same thing
@chars = $string =~ /(\X)/g;        # 6 "letters" in @chars

join("", reverse $string =~ /\X/g); # use \X and =~ 

#1.9. Canonicalizing Strings with Unicode Combined Characters
use Unicode::Normalize;
$s1 = "fa\x{E7}ade";                
$s2 = "fac\x{0327}ade";                
if (NFD($s1) eq NFD($s2)) { print "Yup!\n" }

#1.10. Treating a Unicode String as Octets

$ff = "\x{FB00}";             # ff ligature
$chars = length($ff);         # length is one character
{ 
  use bytes;                  # force byte semantics
  $octets = length($ff);      # length is two octets
}

$ff_oct = encode_utf8($ff);   # convert to octets

#1.11. Expanding and Compressing Tabs
$string =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e #$` (PREMATCH)  , $& (ENTIRE_STRING) or $' (POSTMATCH)

use Text::Tabs;
@expanded_lines  = expand(@lines_with_tabs);
@tabulated_lines = unexpand(@lines_without_tabs);

#1.12. Expanding Variables in User Input
$string = "You owe $debt to me."
$text =~ s/\$(\w+)/${$1}/g;

$text = 'I am $AGE years old';      # note single quotes
$text =~ s/(\$\w+)/$1/eg;           # WRONG $1 eval to $AGE 
$text =~ s/(\$\w+)/$1/eeg;          # finds my( ) variables

#1.13. Controlling Case
$big = uc($little); # $big = "\U$little";
$little = lc($big); # $little = "\L$big";
#ucfirst ($str)
#lcfirst ($str)

$text =~ s/(\w+)/\u\L$1/g; #This Is A Long Line

#1.14. Properly Capitalizing a Title or Headline

#1.15. Interpolating Functions and Expressions Within Strings
$answer = $var1 . func( ) . $var2;   # scalar only

#Only @, $, and \ are special within "" and most `
$answer = "STRING @{[ LIST EXPR ]} MORE STRING";
$answer = "STRING ${\( SCALAR EXPR )} MORE STRING";

die "Couldn't send mail" unless send_mail(<<"EOTEXT", $target);
To: $naughty
From: Your Bank
Cc: @{ get_manager_list($naughty) }
Date: @{[ do { my $now = `date`; chomp $now; $now } ]} (today)

Sincerely,
the management
EOTEXT


#1.16. Indenting Here Documents
$var = << HERE_TARGET;
    your text
    goes here
HERE_TARGET
$var =~ s/^[^\S\n]+//gm; #\s matches newlines


#1.17. Reformatting Paragraphs
use Text::Wrap      qw(&wrap $columns);
use Term::ReadKey   qw(GetTerminalSize); # get windows' size
($columns) = GetTerminalSize( ); # colums is text's width
($/, $\)  = ('', "\n\n");   # $/ = '' to read in paragraphs
while (<>) {                
    s/\s*\n\s*/ /g;         # convert intervening newlines to spaces
    print wrap($leadtab, $nexttab, $_); 
}

#use Text::Autoformat for smarter formatting 

#1.18. Escaping Characters
$var =~ s/([CHARLIST])/\\$1/g; # backslash
$var =~ s/([CHARLIST])/$1$1/g; # double

#1.19. Trimming Blanks from the Ends of a String
$string =~ s/^\s+//;
$string =~ s/\s+$//;

chomp; #removes the last part, if it contains in $/

sub trim {
    my @out = @_ ? @_ : $_;
    $_ = join(' ', split(' ')) for @out; #$_ = changes the cur element
    return wantarray ? @out : "@out";
}

use Text::ParseWords;
quotewords("," => 0, $_[0]); # => enquotes LHS, 2nd arg if fields in quotes

#1.20. Parsing Comma-Separated Data
use Text::CSV; #CPAN

my $csv = Text::CSV->new( );              
@fields = $csv->parse($line) && $csv->fields( );

tie @data, "Tie::CSV_File", "data.csv";

for ($i = 0; $i < @data; $i++) {
    for ($j = 0; $j < @{$data[$i]}; $j++) { # @{$data[$i]} ????
        print "Column $j is <$data[$i][$j]>\n";
    } 
}


#1.21. Constant Variables
use constant AVOGADRO => 6.02252e23; #creates a global sub

*AVOGADRO = \6.02252e23; # "*" specifier for a symbol table 
print "You need $AVOGADRO of those for guac\n"; #also used to create aliases (e.g. *this = *that)

our $AVOGADRO; #if "use strict" pragma is in effect
local *AVOGADRO = \6.02252e23; #our creates an alias to an existing name

#implement a small tie class for consts 

#1.22. Soundex Matching

use Text::Soundex;
use Text::Metaphone;

#1.23. Program: fixstyle

#changes all occurrences of each element in the first set 
#to the corresponding element in the second set

#1.24. Program: psgrep

#psgrep script is given
psgrep 'uid < 10' #queries on psgrep

#2.1. Checking Whether a String Is a Valid Number
use Regexp::Common;

#RE is hash containing canned RegExs
# /x ignores blanks in a pattern (readibility)
$string =~ / ^   $RE{num}{int}  $ /x 

$RE{num}{int}{-sep=>',?'}              # match 1234567 or 1,234,567
$RE{num}{int}{-sep=>'.'}{-group=>4}    # match 1.2345.6789
$RE{num}{int}{-base => 8}              # match 014 but not 99
$RE{num}{int}{-sep=>','}{-group=3}     # match 1,234,594
$RE{num}{int}{-sep=>',?'}{-group=3}    # match 1,234 or 1234
$RE{num}{real}                         # match 123.456 or -0.123456
$RE{num}{roman}                        # match xvii or MCMXCVIII
$RE{num}{square}                       # match 9 or 256 or 12321

#POSIX::strtod needs extra checks and handling
sub getnum {
    use POSIX qw(strtod);
    my $str = shift;
    $str =~ s/^\s+//;           # remove leading whitespace
    $str =~ s/\s+$//;           # remove trailing whitespace
    $! = 0;
    my($num, $unparsed) = strtod($str);
    if (($str eq '') || ($unparsed != 0) || $!) {
        return;
    } else {
        return $num;
    } 
} 

#2.2. Rounding Floating-Point Numbers
$rounded = sprintf("%.2f", $unrounded);

$a = 0.625;                # 0.625 is 0.625
$b = 0.725;                # 0.725 is 0.724999999999999977795539507497
printf "$_ is %.30g\n", $_ for $a, $b;

#Perl rounds .5 toward even

#2.3. Comparing Floating-Point Numbers
sub equal {
    my ($A, $B, $dp) = @_;
    return sprintf("%.${dp}g", $A) eq sprintf("%.${dp}g", $B);
  }

  
foreach ($X .. $Y) {...} 
foreach $i ($X .. $Y) {...} #loop-scoped
for ($i = $X; $i <= $Y; $i++) {...} #NOT loop-scoped
for (my $i=$X; $i <= $Y; $i++) { ... }

#2.5. Working with Roman Numerals
use Roman;
$roman = roman($arabic);                        
$arabic = arabic($roman) if isroman($roman); 

use Math::Roman qw(roman);
print $a  = roman('I'); #  I
print $a += 2000;       #  MMI   

print "2003 is", "\N{ROMAN NUMERAL ONE THOUSAND}" x 2, "\N{ROMAN NUMERAL THREE}\n";

#2.6. Generating Random Numbers
$random = int( rand(51)) + 25;
$elt = $array[ rand @array ];

@chars = ( "A" .. "Z", "a" .. "z", 0 .. 9, qw(! @ $ % ^ & *) );
$password = join("", @chars[ map { rand @chars } ( 1 .. 8 ) ]);

#2.7. Generating Repeatable Random Number Sequences
srand( 42 );  # pick any fixed starting point

#2.8. Making Numbers Even More Random
use Math::TrulyRandom;
$random = truly_random_value( );

use Math::Random;
$random = random_uniform( );

#2.10. Doing Trigonometry in Degrees, Not Radians
sub deg2rad {
    my $degrees = shift;
    return ($degrees / 180) * PI;
}

sub rad2deg {
    my $radians = shift;
    return ($radians / PI) * 180;
}

use Math::Trig;

$radians = deg2rad($degrees);
$degrees = rad2deg($radians);

#2.11. Calculating More Trigonometric Functions

#2.12. Taking Logarithms
$log_e = log(VALUE);

use POSIX qw(log10);
$log_10 = log10(VALUE);

#2.13. Multiplying Matrices

#2.14. Using Complex Numbers
use Math::Complex;
$a = Math::Complex->new(3,5);               # or Math::Complex->new(3,5);
$b = Math::Complex->new(2,-2);
$c = $a * $b;

$c = cplx(3,5) * cplx(2,-2);                # easier on the eye
$d = 3 + 4*i;                               # 3 + 4i

#2.15. Converting Binary, Octal, and Hexadecimal Numbers
$number = oct($hexadecimal);         # "0x2e" becomes 47
$number = oct($octal);               # "057"  becomes 47
$number = oct($binary);              # "0b101110" becomes 47

print "Gimme an integer in decimal, binary, octal, or hex: ";
$num = <STDIN>;
chomp $num;

#2.16. Putting Commas in Numbers
sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

# \d(?=px) 1pt (2px) 3em (4px) : pos lookahead
# \d(?!px) (1pt) 2px (3em) 4px : neg lookahead

#2.17. Printing Correct Plurals
printf "It took %d hour%s\n", $time, $time =  = 1 ? "" : "s";

use Lingua::EN::Inflect qw(PL classical);
classical(1);               # why isn't this the default?
while (<DATA>) {            # each line in the data
    for (split) {           # each word on the line
        print "One $_, two ", PL($_), ".\n"; #One fish, two fish
    }
} 

#2.18. Program: Calculating Prime Factors
use strict;  #use is a compile time directive
use integer; #use native integers

our ($opt_b, $opt_d);
use Getopt::Std;

require Math::BigInt;    #runtime load
Math::BigInt->import( ); #immaterial?


#3.1. Finding Today’s Date
($DAY, $MONTH, $YEAR) = (localtime)[3,4,5]; #or (localtime)[3..5]
printf("The current date is %04d %02d %02d\n", $year+1900, $month+1, $day);

use Time::localtime;
$tm = localtime; #OO API
($DAY, $MONTH, $YEAR) = ($tm->mday, $tm->mon, $tm->year);

#3.2. Converting DMYHMS to Epoch Seconds
use Time::Local;
$time = timelocal($seconds, $minutes, $hours, (localtime)[3,4,5]);

$time = timegm($seconds, $minutes, $hours, $day, $month-1, $year-1900);

#3.3. Converting Epoch Seconds to DMYHMS
($seconds, $minutes, $hours, $day_of_month, $month, $year,
    $wday, $yday, $isdst) = localtime($time);
printf("Dateline: %02d:%02d:%02d-%04d/%02d/%02d\n",
    $hours, $minutes, $seconds, $year+1900, $month+1,
    $day_of_month);

#OO API
use Time::localtime;        # or Time::gmtime
$tm = localtime($TIME);     # or gmtime($TIME)

#3.4. Adding to or Subtracting from a Date
use Date::Calc qw(Add_Delta_DHMS); 
#full $year, 1-based $month
($year, $month, $day, $hh, $mm, $ss) = Add_Delta_DHMS(
    1973, 1, 18, 3, 45, 50, # 18/Jan/1973, 3:45:50 am
             55, 2, 17, 5); # 55 days, 2 hrs, 17 min, 5 sec

#3.5. Difference of Two Dates
use Date::Calc qw(Delta_DHMS);
@bree = (1981, 6, 16, 4, 35, 25);   # 16 Jun 1981, 4:35:25
@nat  = (1973, 1, 18, 3, 45, 50);   # 18 Jan 1973, 3:45:50
@diff = Delta_DHMS(@nat, @bree); #$diff[0] days, $diff[1]:$diff[2]:$diff[3]


#3.6. Day in a Week/Month/Year or Week Number
($MONTHDAY, $WEEKDAY, $YEARDAY) = (localtime $DATE)[3,6,7];
$WEEKNUM = int($YEARDAY / 7) + 1;


use Date::Calc qw(Day_of_Week Week_Number Day_of_Year);
$wday = Day_of_Week($year, $month, $day);

#3.7. Parsing Dates and Times from Strings
use Date::Manip qw(ParseDate UnixDate);
$date = ParseDate($_);
($year, $month, $day) = UnixDate($date, "%Y", "%m", "%d");

#3.8. Printing a Date
use POSIX qw(strftime);
print "strftime gives: ", strftime("%A %D", localtime($time)), "\n";

#3.9. High-Resolution Timers
use Time::HiRes qw(gettimeofday);
$t0 = gettimeofday( );    
## do your operation here
$t1 = gettimeofday( );
($s, $ms) = gettimeofday( );
#making sys_calls

#3.10. Short Sleeps
#might not be available on windows?
select(undef, undef, undef, $time_to_sleep);

use Time::HiRes qw(sleep); #$time_to_sleep is float
sleep($time_to_sleep);

#3.11. Program: hopdelta
#hopdelta takes a mailer header and tries to analyze
#the deltas between each mail stop 

#Arrays -- Introduction
@nested = ("this", "that", ("the", "other")); #("this", "that", "the", "other")

#4.1. Specifying a List in Your Program
@a = ("quick", "brown", "fox");

@ships  = qw(Niña Pinta Santa María);               # WRONG
@ships  = ('Niña', 'Pinta', 'Santa María');         # right

@ships = ( << "END_OF_FLOTILLA" =~ /^\s*(.+)/gm);
              Niña
              Pinta 
              Santa María
END_OF_FLOTILLA

#4.2. Printing a List with Commas
sub commify_series {
    (@_ =  = 0) ? ''                                      :
    (@_ =  = 1) ? $_[0]                                   :
    (@_ =  = 2) ? join(" and ", @_)                       :
                join(", ", @_[0 .. ($#_-1)], "and $_[-1]");
}

#4.3. Changing Array Size
@people = qw(Crosby Stills Nash Young);
$#people--; #removes one element 
$people[100] = 'boo'; #extended to 100 w/ undefs
$#people = 10_000; #extended to 10_000 w/ undefs
$people[10_000] = undef; #length stays the same

$#foo = 5;
@bar = ( (undef) x 5 ) ;

defined $foo[3] #0
exists $foo[3]  #0
defined $bar[3] #0
exists $bar[3]  #1


#4.4. Implementing a Sparse Array
$fake_array{ 1_000_000 } = 1; 

foreach $element ( @fake_array{ sort {$a <=> $b} keys %fake_array } ) {}
foreach $idx ( sort {$a <=> $b} keys %fake_array ) {}
# $a <=> $b (a,b) => a < b


#4.5. Iterating Over an Array
foreach $item (@array) { 
    $item--; #$item is an alias and loop-scoped
}

#4.6. Iterating Over an Array by Reference
foreach $item (@$ARRAYREF) {
    # do something with $item
}

for ($i = 0; $i <= $#$ARRAYREF; $i++) {
    # do something with $ARRAYREF->[$i]
}

$namelist{felines} = \@rogue_cats;
foreach $cat ( @{ $namelist{felines} } ) {...}

for ($i=0; $i <= $#{ $namelist{felines} }; $i++) {
    print "$namelist{felines}[$i] purrs hypnotically.\n";
}

#4.7. Extracting Unique Elements from a List
%seen = ( );
foreach $item (@list) {
    push(@uniq, $item) unless $seen{$item}++;
}

%seen = ( );
foreach $item (@list) {
    $seen{$item}++;
}
@uniq = keys %seen;

%seen = ( );
@uniq = grep { ! $seen{$_} ++ } @list;

#4.8. Finding Elements in One Array but Not Another
my %seen;     # lookup table
my @aonly;    # answer

# build lookup table
@seen{@B} = ( );

foreach $item (@A) {
    push(@aonly, $item) unless exists $seen{$item};
}

#Loopless version
my %seen;
@seen {@A} = ( ); //values #are undefs only works with exists
delete @seen {@B};

my @aonly = keys %seen;

#
@hash{"key1", "key2"} = (1,2);
@seen{@B} = (1) x @B; 

open(OLD, $path1)        || die "can't open $path1: $!";
@seen{ <OLD> } = ( );
open(NEW, $path2)        || die "can't open $path2: $!";
while (<NEW>) {
    print if exists $seen{$_};  
}

perl -e '@s{`cat OLD`}=( ); exists $s{$_} && print for `cat NEW`'
perl -e '@s{`cat OLD`}=( ); exists $s{$_} || print for `cat NEW`'

#4.9. Computing Union, Intersection, or Difference of UNIQUE Lists
#You have a pair of lists, each holding UNDUPLICATED items

#Initialization code for all solutions below
@union = @isect = @diff = ( );
%union = %isect = ( );
%count = ( );

#works cos the first time item seen 

#since lists are UNIQUE we can only see the same element once or twice
#once, its only added to %union; twice, its added to isect 
#(@a, @b) is cross product
foreach $e (@a, @b) { $union{$e}++ && $isect{$e}++ }

@union = keys %union;
@isect = keys %isect;

@isect = @diff = @union = ( );
foreach $e (@a, @b) { $count{$e}++ }

@union = keys %count;
foreach $e (keys %count) {
    push @{ $count{$e} =  = 2 ? \@isect : \@diff }, $e;
}

#4.10. Appending One Array to Another
@members = ("Time", "Flies");
@initiates = ("An", "Arrow");
push(@members, @initiates); 
# @members is now ("Time", "Flies", "An", "Arrow")

splice(@members, 2, 0, "Like", @initiates); 
#Time Flies Like An Arrow

#4.11. Reversing an Array
foreach $element (reverse @ARRAY) {
    # do something with $element
}

for ($i = $#ARRAY; $i >= 0; $i--) {
    # do something with $ARRAY[$i]
}

#4.12. Processing Multiple Elements of an Array
# remove $N elements from front of @ARRAY (shift $N)
@FRONT = splice(@ARRAY, 0, $N);

# remove $N elements from the end of the array (pop $N)
@END = splice(@ARRAY, -$N);

#4.13. Finding the First List Element That Passes a Test
foreach $item (@array) {
    if (CRITERION) {
        $match = $item;  # must save
        $found = 1;
        last;
    }
}

my ($i, $match_idx);
for ($i = 0; $i < @array; $i++) {
    if (CRITERION) {
        $match_idx = $i;    # save the index
        last;
    }
}

use List::Util qw(first);
$match = first { CRITERION } @list

#4.14. Finding All Elements in an Array Matching Certain Criteria
@MATCHING = grep { TEST ($_) } @LIST;

#4.15. Sorting an Array Numerically
@sorted = sort { $a <=> $b } @unsorted;

package Sort_Subs;
#$a and $b mapped to 
#different $a and $b in different package
sub revnum { $b <=> $a } 

package Other_Pack;
@all = sort Sort_Subs::revnum 4, 19, 8, 3; #use a routine

#4.16. Sorting a List by Computable Field
@precomputed = map { [compute( ),$_] } @unordered; #precompute if compute is expensive
@ordered_precomputed = sort { $a->[0] <=> $b->[0] } @precomputed;
@ordered = map { $_->[1] } @ordered_precomputed;

#4.17. Implementing a Circular List
unshift(@circular, pop(@circular));  # the last shall be first
push(@circular, shift(@circular));   # and vice versa

#4.18. Randomizing an Array
use List::Util qw(shuffle);
@array = shuffle(@array);

$value = $array[ int(rand(@array)) ]; #a rand element

#4.19. Program: words
#ls generate columns of sorted output that you read down 
#the columns instead of across the rows?
 
#4.20. Program: permute

#Chapter 5. Introduction
%food_color = (Apple  => "red") #=> quotes any word preceding it

#5.1. Adding an Element to a Hash
$food_color{Raspberry} = "pink"; 
print $_ foreach (keys %food_color);

#5.2. Testing for the Presence of a Key in a Hash
$food_color{Glass} = "undef"; 
print "Exists "  if exists  $food_color{Glass}; #Exists
print "Defined " if defined $food_color{Glass}; #<>

#5.3. Creating a Hash with Immutable Keys or Values
use Hash::Util qw{ lock_keys  unlock_keys
                   lock_value unlock_value
                   lock_hash  unlock_hash  }; 
				   
lock_keys(%hash);                # restrict to current keys
lock_keys(%hash, @klist);        # restrict to keys from @klist

lock_value(%hash, $key); #forbid deletion of the key or modification of its value

lock_hash(%hash); #make  all keys and their values read-only

#Perl always creates hash elements on demand
#Misspelled names will be created on demand 

#5.4. Deleting from a Hash
delete($HASH{$KEY}); #don't use =undef!!!
delete @food_color{"Banana", "Apple", "Cabbage"};
delete @food_color{@keys_to_remove};

#5.5. Traversing a Hash
while(($key, $value) = each(%HASH)) {...}

foreach $key (keys %HASH) {
    print $HASH{$key};
}

#5.6. Printing a Hash
while ( ($k,$v) = each %hash ) {
    print "$k => $v\n";
}

print map { "$_ => $hash{$_}\n" } keys %hash;

print "@{[ %hash ]}\n"; #interpolation trick

#5.7. Retrieving from a Hash in Insertion Order
use Tie::IxHash;

tie %food_color, "Tie::IxHash"; #ties a var to a pkg impl
$food_color{"Banana"} = "Yellow";
$food_color{"Apple"}  = "Green";

#also provides OO interface to splice, push 
#pop, shift, unshift, keys, values, and delete


#5.8. Hashes with Multiple Values per Key
push( @{$ttys{$user}}, $tty ); #or splice

foreach $tty (sort @{$ttys{$user}}) { .. }

#5.9. Inverting a Hash
%REVERSE = reverse %LOOKUP; # %LOOKUP maps keys to values

#only works for unique values

%surname = ( "Mickey" => "Mantle", "Babe" => "Ruth" );

#%surname as a list
("Mickey", "Mantle", "Babe", "Ruth")

#reversing the list 
("Ruth", "Babe", "Mantle", "Mickey")

#5.10. Sorting a Hash

#This sorts the keys by their associated values:
foreach $food (sort { $food_color{$a} cmp $food_color{$b} } (..)

#This sorts by length of the values:
@foods = sort { length($food_color{$a}) <=> length($food_color{$b}) } keys %food_color;

#5.11. Merging Hashes

#only the first value of duplicate keys is merged 
%merged = (%A, %B);

%merged = ( );
while ( ($k,$v) = each(%A) ) {
    $merged{$k} = $v;
}
while ( ($k,$v) = each(%B) ) {
    $merged{$k} = $v;
}
	
foreach $substanceref ( \%A, \%B ) {
    while (($k, $v) = each %$substanceref) {
        $substance_color{$k} = $v;
    }
}	

#5.12. Finding Common or Different Keys in Two Hashes
my @common = ( ); # @common will contain common keys
foreach (keys %hash1) {
        push(@common, $_) if exists $hash2{$_};
}

my @this_not_that = ( ); #diff of two key sets
foreach (keys %hash1) {
        push(@this_not_that, $_) unless exists $hash2{$_};
}

#or use keys %HASH and apply recipes from 4.9

#5.13. Hashing References
#( ref => ref )-like hashes don't work!

use Tie::RefHash;
tie %hash, "Tie::RefHash";
# you may now use references as the keys to %hash

tie %name, "Tie::RefHash";
foreach $filename ("/etc/termcap", "/vmunix", "/bin/cat") {
    $fh = IO::File->new("< $filename") or next;
    $name{$fh} = $filename;
}

#5.14. Presizing a Hash

# presize %hash to $num
#needs to be a power of 2
keys(%hash) = $num;

#5.15. Finding the Most Common Anything
%count = ( );
foreach $element (@ARRAY) {
    $count{$element}++;
}

#5.16. Representing Relationships Between Data

#5.17. Program: dutree

#7 Introduction

#Pattern-Matching Modifiers

#/x Ignore most whitespace in pattern and permit comments
#/gc Don’t reset search position on failed match
#/s Let . match newline
#/m Let ^ and $ match next to embedded \n
#/o Compile pattern once only
#/e Righthand side of an s/// is code whose result is used as the replacement value
#/ee Righthand side of an s/// is a string that’s eval‘d twice; the final result then used as the replacement value

my $digits = "123456789"
@yeslap = $digits =~ /(?=(\d\d\d))/g; # 123 234 345 456 567 678 789  
s/(\d+)/sprintf("%#x", $1)/ge #converts all numbers into hex

$string = "And little lambs eat ivy";
$string =~ /l[^s]*s/;
print "($`) ($&) ($´)\n"; #(And ) (little lambs) ( eat ivy)

#$` substr($string, 0, $-[0]) #@- and @+, first introduced in Perl v5.6
#$& substr($string, $-[0], $+[0] - $-[0])
#$´ substr($string, $+[0])
#$1 substr($string, $-[1], $+[1] - $-[1])

#6.1. Copying and Substituting Simultaneously

($dst = $src) =~ s/this/that/;

for (@libdirs = @bindirs) { s/bin/lib/ }
print "@libdirs\n";

($a =  $b) =~ s/x/y/g;      # 1: copy $b and then change $a
 $a = ($b  =~ s/x/y/g);     # 2: change $b, count goes in $a
 $a =  $b  =~ s/x/y/g;      # 3: same as 2
  
#6.2. Matching Letters
if ($var =~ /^[A-Za-z]+$/) {
    # it is purely alphabetic
}

if ($var =~ /^\p{Alphabetic}+$/) {   # or just /^\pL+$/
    print "var is purely alphabetic\n";
}

if ($var =~ /^[^\W\d_]+$/) {
    print "var is purely alphabetic\n";
}

if ($var =~ /^[[:alpha:]]+$/) {
    print "var is purely alphabetic\n";
}

#6.3. Matching Words
/\S+/               # as many non-whitespace characters as possible
/[A-Za-z'-]+/       # as many letters, apostrophes, and hyphens
/\b([A-Za-z]+)\b/            # matches '
/\s([A-Za-z]+)\s/            # fails at ends or w/ punctuation


#6.4. Commenting Regular Expressions 

/                 
  (\w+)  #   the variable name
/x;      #   /x ignores whitespaces outside [] and comments
#
$optional_sign      = '[-+]?';
$mandatory_digits   = '\d+';

$number = "(?:" #split a regex into logical groups
        .   $optional_sign    
        .   $mandatory_digits  
		. ")";	

#		
$hex_digit = '(?i:[0-9a-z])'; #group-specific modifier  		
#		
$optional_sign      = qr/[-+]?/i;
$mandatory_digits   = qr/\d+/;

$number = qr{ 
                 $optional_sign    
                 $mandatory_digits       
          }x; # needs a diff delimeter "{" 
		

#6.5. Finding the Nth Occurrence of a Match

/(?:\w+\s+fish\s+){2}(\w+)\s+fish/i; #word preceding 3rd occurence of fish

$count = 0; $count++ while $string =~ /PAT/g;		
for ($count = 0; $string =~ /PAT/g; $count++) { }
$count++ while $string =~ /(?=PAT)/g; #count overlapping matches

@colors = ($pond =~ /(\w+)\s+fish\b/gi);      # get all matches
@evens = grep { $count++ % 2 =  = 0 } /(\w+)\s+fish\b/gi; #even-numbered

#6.6. Matching Within Multiple Lines

#/m allows ^ and $ to match next to an embedded newline, 
#whereas /s allows . to match newlines

undef $/;             # each read is whole file
  while (<>) {        # get one whole file at a time
    s/<.*?>//gs;    # strip tags (terribly)
  }
  
  
#6.7. Reading Records with a Separator  
 
undef $/; #reads in the whole file 
@chunks = split(/pattern/, <FILEHANDLE>);
 
#Perl’s official record separator, 
#the $/ variable, must be a fixed string

#6.8. Extracting a Range of Lines

while (<>) {
	#if (FIRST_LINE_NUM .. LAST_LINE_NUM)
    if (/BEGIN PATTERN/ .. /END PATTERN/) {...} 
}

#.. tests the right operand on the same iteration
#... operator waits until the next iteration 

$in_body   = /^$/ .. eof( ); # .. allows any operands 

#6.9. Matching Shell Globs as Regular Expressions
my $raw_string = "\Q$string"; #non-ASCII chars are escaped

#6.10. Speeding Up Interpolated Matches
while ($line = <>) {
    if ($line =~ /$pat/o) {...} # /o compiles $pat
}   #$pattern compiled once, any changes to $pat are ignored

@pats = map { qr/$_/ } @strings; #qr compiles @strings into patterns

#6.11. Testing for a Valid Pattern
eval { "" =~ /$pat/ };
warn "INVALID PATTERN $@" if $@; #$@ is set on error

$pat = "You lose @{[ system('rm -rf *')]} big here";

#6.12. Honoring Locale Settings in Regular Expressions
use locale;

#6.13. Approximate Matching

use String::Approx qw(amatch);

#fuzzy match 10% of i/d/s of string's length
if (amatch("PATTERN", @list)) {...} 

#6.14. Matching from Where the Last Pattern Left Off
while (/(\d+)/g) {...} # /g enables a progressive match

$n =~ s/\G /0/g;
#\G means the end of the previous match
#\G equals to ^ at the beginning of a string


while (/(\d+)/gc) {...} #/c doesnt reset pos after an unsuccessful match
if (/\G(\S+)/g) {...}   #continue from the last match 

#6.15. Greedy and Non-Greedy Matches

#6.16. Detecting Doubled Words

#a paragraph—a chunk of text terminated 
#by two or more contiguous newlines.

/([A-Z])\1/ #captures double letters. 


$string = q("I can't see this," she remarked.);

@a = $string =~ /\b\S+\b/g; #matches I, this
@b = $string =~ /\S+/g;# matches "I, this,"


#perl has to give up on the greedy match "nobody"
#otherwise it won't match \2
$a = 'nobody';
$b = 'bodysnatcher';
if ("$a $b" =~ /^(\w+)(\w+) \2(\w+)$/) {
	print "$2 overlaps in $1-$2-$3\n"; 
	#body overlaps in no-body-snatcher
}

#can even be used to solve 12x + 15y + 16z = 281

#6.17. Matching Nested Patterns

#??{ CODE } can recursively refer to a defining pattern

# $(??{ CODE }) runs CODE and embeds back into a pattern
if ($word =~ /^(\w+)\w?(??{reverse $1})$/ ) { #w? is a pivot


use Regexp::Common;
if ($text =~ /(\w+\s*$RE{balanced}{-parens=>'( )'})/o) {...}
#$RE provides canned patterns 

use Text::Balanced qw/extract_bracketed/;

if (($before, $found, $after)  = extract_bracketed($text, "(")) 
{...}

#6.18. Expressing AND, OR, and NOT in a Single Pattern

#6.19. Matching a Valid Mail Address

#The Email::Valid CPAN module 
#makes best effort to conform to RFC


#6.20. Matching Abbreviations

#Auto completation/live search
chomp($answer = <>);
if    ("SEND"  =~ /^\Q$answer/i) { print "Action is send\n"  }
elsif ("STOP"  =~ /^\Q$answer/i) { print "Action is stop\n"  }
else ...

use Text::Abbrev; 
$href = abbrev qw(send abort list edit);
for (print "Action: "; <>; print "Action: ") {
    chomp; 
    my $action = $href->{ lc($_) };
}

#6.21. Program: urlify
#This program puts HTML links around URLs in files.

#6.22. Program: tcgrep
#This program is a Perl rewrite of the Unix grep program.

#7

my $input;                            
open(INPUT, "<", "/acme/widgets/data")  #INPUT is unadorned (e.g. no $)
open($input, "<", "/acme/widgets/data") #since v5.6 indirect refs are allowed 

while (<$input>) { print if /blue/; }
close($input); 

#The built-in filehandles STDIN, STDOUT, STDERR, 
#ARGV Perl opens/reads files in succession from @ARGV

open(LOGFILE, "> /tmp/log") #< > >>

#system error message as a string 
#and its numeric code in the $! variable

$old_fh = select(LOGFILE); # switch stdout to LOGFILE



