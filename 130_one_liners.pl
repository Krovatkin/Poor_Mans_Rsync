#Chapter 1. Introduction to Perl One-Liners
perl -ne 'print if $a{$_}++' file #all lines in a file that appear more than once
perl -ne 'print "$. $_"' file # numbering lines

perl -MList::Util=sum -alne 'print sum @F' #-MMODULE=foo,bar or -MMODULE qw(foo bar)'

#2.1 Double-space a file
while (<>) {
    # your program goes here (specified by -e)
} continue {
    print or die "-p failed: $!\n";
}

perl -pe '$\ = "\n"' file #double-space, $\ is a rec sep, $, is a field sep, $_ already includes a newline
perl -pe 's/$/\n/' file
perl -nE 'say' file

perl -pe '$_ .= "\n" if /\S/' #ignore whitespace characters

#2.5 Add a blank line before every line
perl -pe 's/^/\n/' 

perl -00 -pe '' # -00 is a paragraph mode
perl -00pe0

perl -pe 's/ /  /g' #double space words

#3.1 Number all lines in a file
perl -ne 'print "$. $_"'

#3.2 Number only non-empty lines in a file
perl -pe '$_ = ++$x." $_" if /./' 

#3.8 Number all lines in a file using a custom format
perl -ne 'printf "%-5d %s", $., $_' # -5 left-justify with 5 spaces, 05 right-justify with zeros

#3.9 Print the total number of lines in a file (emulate wc -l)
perl -lne 'END { print $. }'
perl -le 'print $n = (() = <>)' 

#3.10 Print the number of non-empty lines in a file
perl -le 'print scalar(grep { /./ } <>)'
perl -le 'print~~grep/./,<>' #bitwise negation uses a scalar context
perl -lE 'say~~grep/./,<>'

#3.11 Print the number of empty lines in a file
perl -lne '$x++ if /^$/; END { print $x+0 }' #+0 to turn undefined into 0
perl -lne '$x++ if /^$/; END { print int $x }'


#3.13 Number words across all lines
perl -pe 's/(\w+)/++$i.".$1"/ge' # /e flag makes perl evaluate the replace expression

#3.14 Number words on each individual line
perl -pe '$i=0; s/(\w+)/++$i.".$1"/ge' 

#4.3 Print the sum of all fields on all lines
perl -MList::Util=sum -alne 'push @S,@F; END { print sum @S }' #push APPENDS @F 

#4.4 Shuffle all fields on each line
perl -MList::Util=shuffle -alne 'print "@{[shuffle @F]}"' #@{ ... } derefs an array, [shuffle @F] -- anonymous array


#4.5 Find the numerically smallest element (minimum element) on each line
perl -MList::Util=min -alne 'print min @F'

perl -MList::Util=min -alne '$min = min($min // (), @F); END { print $min }' # returns () if $min is undef, ((), @F) gets flattened 

#4.9 Replace each field with its absolute value
perl -alne 'print "@{[map { abs } @F]}"'

#4.11 Print the total number of fields on each line, followed by the line
perl -alne 'print scalar @F, " $_"'

#4.13 Print the total number of fields that match a pattern

perl -alne 'map { /regex/ && $t++ } @F; END { print $t || 0 }'
perl -alne '$t += /regex/ for @F; END { print $t }'
perl -alne '$t += grep /regex/, @F; END { print $t }' #in scalar ctx grep returns the num of matches

#4.14 Print the total number of lines that match a pattern
perl -lne '/regex/ && $t++; END { print $t || 0 }'

#4.17 Print UNIX time
perl -le 'print time'

#4.18 Print Greenwich Mean Time and local computer time
perl -le 'print scalar localtime' #gmtime for GMT

#both return a tm struct (see below) in list ctx
#   0    1    2     3     4    5     6     7     8
#($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =

perl -le 'print join ":", (localtime)[2,1,0]' # (localtime)[2..6] , (localtime)[-2, -3]'

perl -MPOSIX -le '@now = localtime; $now[0] -= 7; $now[3] -= 9; $now[4] -= 14; print scalar localtime mktime @now'

#4.21 Calculate the factorial
perl -MMath::BigInt -le 'print Math::BigInt->new(5)->bfac()'
perl -le '$f = 1; $f *= $_ for 1..5; print $f'

#4.22 Calculate the greatest common divisor
perl -MMath::BigInt=bgcd -le 'print bgcd(@list_of_numbers)'

#4.24 Generate 10 random numbers between 5 and 15 (excluding 15)
perl -le 'print join ",", map { int(rand(15-5))+5 } 1..10'

#4.25 Generate all permutations of a list
perl -MAlgorithm::Permute -le '$l = [1,2,3,4,5]; $p = Algorithm::Permute->new($l); print "@r" while @r = $p->next'

#4.26 Generate the powerset
perl -MList::PowerSet=powerset -le '@l = (1,2,3,4,5); print "@$_" for @{powerset(@l)}' 

#4.27 Convert an IP address to an unsigned integer
perl -le '$i=3; $u += ($_<<8*$i--) for "127.0.0.1" =~ /(\d+)/g; print $u'

#5.1 Generate and print the alphabet
perl -le '$, = ","; print ("a".."z")' # $, a field sep for print 

perl -le '$alphabet = join ",", ("a".."z"); print $alphabet' 

#5.2 Generate and print all the strings from “a” to “zz”
perl -le 'print join ",", ("a".."zz")'

#5.3 Create a hex lookup table
perl -le 'printf("%x", 255)'
perl -le '$num = "ff"; print hex $num'

#5.4 Generate a random eight-character password
perl -le 'print map { ("a".."z", 0..9)[rand 36] } 1..8'


#5.5 Create a string of specific length
perl -le 'print "a"x50'

perl -le '@list = (1,2)x20; print "@list"'


#5.6 Create an array from a string
@months = split ' ', "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
@months = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/

#5.8 Find the numeric values for characters in a string
perl -le 'print join ", ", unpack("C*", "hello world")'

perl -le '  print join ", ", map { sprintf "0x%x", ord $_ } split //, "hello world" ' #sprintf, hex values

#5.9 Convert a list of numeric ASCII values into a string
perl -le '@ascii = (99, 111, 100, 105, 110, 103); print pack("C*", @ascii) '

perl -le 'print map chr, @ARGV' 99 111 100 105 110 103

#5.12 Find the length of a string
perl -le 'print length "one-liners are great"'


#5.13 Find the number of elements in an array
perl -le '@array = ("a".."z"); print scalar @array' #array length

perl -le 'print scalar (@ARGV=<*.txt>)' # <> does glob

#6.1 ROT13 a string
perl -le '$string = "bananas"; $string =~ y/A-Za-z/N-ZA-Mn-za-m/; print $string' #y or tr

$cnt = $sky =~ tr/*/*/; # y/ returns the number of replacements, useful for counting 

#d Delete found but unreplaced characters.
#s Squash duplicate replaced characters.
#r Return the modified string and leave the original string untouched.

#6.2 Base64-encode a string
perl -MMIME::Base64 -e 'print encode_base64("string")'

#6.3 Base64-decode a string
perl -MMIME::Base64 -le 'print decode_base64("base64string")'

#6.4 URL-escape a string
perl -MURI::Escape -le 'print uri_escape("http://example.com")'

#6.5 URL-unescape a string
perl -MURI::Escape -le 'print uri_unescape("http%3A%2F%2Fexample.com")'

#6.6 HTML-encode a string
perl -MHTML::Entities -le 'print encode_entities("<html>")'

#6.7 HTML-decode a string
perl -MHTML::Entities -le 'print decode_entities("&lt;html&gt;")'

#6.8 Convert all text to uppercase/lowercase
perl -nle 'print uc' #lc

perl -nle 'print "\U$_"' #"\L$_"'

#6.10 Uppercase only the first letter of each line
 perl -nle 'print ucfirst lc'
  
#6.10 Uppercase only the first letter of each line
perl -nle 'print ucfirst lc'

perl -nle 'print "\u\L$_"'

#6.11 Invert the letter case
perl -ple 'y/A-Za-z/a-zA-Z/'

#6.12 Title-case each line
perl -ple 's/(\w+)/\u$1/g'

#6.13 Strip leading whitespace (spaces, tabs) from the beginning of each line
perl -ple 's/^[ \t]+//' # 's/[ \t]+$//'

perl -ple 's/^\s+//' # 's/\s+$//'

#6.15 Strip whitespace (spaces, tabs) from the beginning and end of each line
perl -ple 's/^[ \t]+|[ \t]+$//g' #g is required to make both leading/trailing spaces removed

#6.16 Convert UNIX newlines to DOS/Windows newlines
perl -pe 's|\012|\015\012|' # \r\n might have different encodings

#6.20 Substitute (find and replace) “foo” with “bar” on lines that match “baz”
perl -pe '/baz/ && s/foo/bar/'

#6.21 Print paragraphs in reverse order
perl -00 -e 'print reverse <>' file #-00 reads by paragraph

#6.22 Print all lines in reverse order
perl -lne 'print scalar reverse $_' 

#6.23 Print columns in reverse order
perl -F: -alne '$" = ":"; print "@{[reverse @F]}"' # $" is an element separator when array printed

#7.1 Print the first line of a file (emulate head -1)
perl -ne 'print; exit' file

#7.3 Print the last line of a file (emulate tail -1)
perl -ne '$last = $_; END { print $last }' file

perl -ne 'print if eof' file #eof peeks the next char; if fails signal eof 

#7.4 Print the last 10 lines of a file (emulate tail -10)
perl -ne 'push @a, $_; @a = @a[@a-10..$#a] if @a>10; END { print @a }' file

perl -ne 'push @a, $_; shift @a if @a>10; END { print @a }' file

#7.5 Print only lines that match a regular expression
perl -ne '/regex/ && print'

perl -ne 'print if /regex/'

#7.6 Print only lines that do not match a regular expression
perl -ne '!/regex/ && print'
perl -ne 'print if !/regex/'
perl -ne 'print unless /regex/'
perl -ne '/regex/ || print'

#7.7 Print every line preceding a line that matches a regular expression
perl -ne '/regex/ && $last && print $last; $last = $_'

#7.8 Print every line following a line that matches a regular expression
perl -ne 'if ($p) { print; $p = 0 } $p++ if /regex/'

#7.9 Print lines that match regular expressions AAA and BBB in any order
perl -ne '/AAA/ && /BBB/ && print'

#7.11 Print lines that match regular expression AAA followed by BBB followed by CCC
perl -ne '/AAA.*BBB.*CCC/ && print'

#7.16 Print only lines 13, 19, and 67
perl -ne '@lines = (13, 19, 88, 290, 999, 1400, 2000);
  print if grep { $_ == $. } @lines'
  
#7.17 Print all lines from 17 to 30
perl -ne 'print if 17..30'
  
#7.18 Print all lines between two regular expressions (including the lines that match)
perl -ne 'print if /regex1/../regex2/'

#7.19 Print the longest line
perl -ne '$l = $_ if length($_) > length($l); END { print $l }'

#7.26 Print all repeated lines only once
perl -ne 'print if ++$a{$_} == 2'

#7.27 Print all unique lines
perl -ne 'print unless $a{$_}++'
