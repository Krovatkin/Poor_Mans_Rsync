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
