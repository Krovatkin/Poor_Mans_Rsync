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
