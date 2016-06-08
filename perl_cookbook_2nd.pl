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
quotewords("," => 0, $_[0]); # => enquotes LHS, 2nd arg