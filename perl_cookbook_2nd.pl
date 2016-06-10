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