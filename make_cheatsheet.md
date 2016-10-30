### Rules
```make
%.o : %.c
        $(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@    # Pattern Rules

$(objects): %.o: %.c                               # Static Pattern Rule
        $(CC) -c $(CFLAGS) $< -o $@
```



### Implicit Rules 

```make
$(CC) $(CPPFLAGS) $(CFLAGS) -c                      # C
$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c                   # C++
$(CC) $(LDFLAGS) n.o $(LOADLIBES) $(LDLIBS)         # Linker
$(AS) $(ASFLAGS)                                    # Assembler
$(YACC) $(YFLAGS)                                   # n.y -> n.c 
$(LEX) $(LFLAGS)                                    # n.l -> n.c
```
[More](https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html#Catalogue-of-Rules)

### Command Modifies 

```make
@echo "Hello"               # Causes the command not to be echoed before it is executed.
-rm non_existing_file       # Causes any nonzero exit status of the command line to be ignored.
+echo "Hello"               # Causes a command line to be executed, even though the options -n, -q, or -t are specified
```

### Define

```make
VARIABLE
VARIABLE = foo.c        # lazy eval (see more)[#lazy-eager]
VARIABLE :=             # eager 
VARIABLE ::=            # eager
VARIABLE +=             # inherits eval type
VARIABLE ?=             # lazy unless specified on a command line (see more)[#question-equal]
```

#### Undefine

```make
undefine VARIABLE
```

#### Multi-line define

```make
define two-lines =
echo foo
echo $(bar)
endef
```
### Conditionals

```make
ifdef VARIABLE         # ifndef VARIABLE
ifeq (a, a)            # true
ifeq (a,a )            # false 
ifeq "a" "b"           # == ifeq 'a' 'b' 

ifneq 'a' 'b'
else
endif
```

### Include

```make
include file          #
-include file         # no error
sinclude file         # == -include
```

### Varaibles

#### Automatic

Var|Meaning
---|---
`$@`|The file name of the target.
`$%`|The target member name, when the target is an archive member.
`$<`|The name of the first prerequisite.
`$?`|The names of all the prerequisites that are newer than the target, with spaces between them. For prerequisites which are archive members, only the named member is used (see Archives).
`$^`|The names of all the prerequisites, with spaces between them. Omits duplicate prerequisites
`$+`|The names of all the prerequisites, with spaces between them. Retains duplicate prerequisites
`$*`|The stem with which an implicit rule matches
`$(@D)`| The directory part of the target
`$(@F)`| The file name of the target

#### Pre-defined 

```make
VPATH
SHELL
MAKESHELL              # On MS-DOS only, the name of the command interpreter
MAKE
MAKE_VERSION
MAKELEVEL
MAKEFLAGS              # GNUMAKEFLAGS
MAKECMDGOALS           # The targets given to make on the command line.
CURDIR
SUFFIXES
.LIBPATTERNS           # Defines the naming of the libraries make searches for, and their order.
```

### Functions

#### Control Flow

Function|Comments
---|---
`$(if condition,then-part[,else-part])`|
`$(or condition1[,condition2[,condition3…]])`|
`$(and condition1[,condition2[,condition3…]])`|
`$(and condition1[,condition2[,condition3…]])`|Evaluate the variable var replacing any references to $(1), $(2)
`$(eval text)`|Evaluate text then read the results as makefile commands. Expands to the empty string.


#### String 

Function|Comments
---|---
`$(subst from,to,text)`|
`$(patsubst pattern,replacement,text)`|Patterns *using* `%`
`$(strip string)`|
`$(findstring find,text)`|

#### List 

Function|Comments
---|---
`$(filter pattern…,text)`| Multiple patterns 
`$(filter-out)`| 
`$(sort list)`|
`$(word n,text)`|Extract the nth word (one-origin) of text 
`$(wordlist s,e,text)`|
`$(words text)`|Count the number of words in text
`$(firstword names…)`| `$(lastword names…)`
`$(join list1,list2)`|

#### File System

Function|Comments
---|---
`$(wildcard pattern…)`| Multiple patterns 
`$(abspath names…)`| `$(realpath names…)`
`$(shell command)`|



#### Messages

Function|Comments
---|---
`$(info text...)`| 
`$(warning text...)`|
`$(error text...)`|

### Exports

```make
export VARIABLE
export VARIABLE=${FOO}
unexport 
prog: private VARIABLE = foo.c    #NOT inherited by prereqs
```

### Examples

#### Question Equal

```make
BAR = IMMEDIATE
VAR ?= TWO ${BAR}

$(info ${VAR})

BAR = LAZY
$(info ${VAR})
```
#### Lazy Eager

```make
VAR := TWO
VAR += THREE
$(info ${VAR})
```