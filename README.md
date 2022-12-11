![](https://github.com/senselogic/SWITCH/blob/master/LOGO/switch.png)

# Switch

Database converter.

## Import formats

*   SQL
*   CSV

## Export formats

*   Basil
*   CSV
*   Text

## Template syntax

The table rows can be exported to custom text files using a Lisp-like syntax.

```javascript
(
    (
        ( table.Name == "CHARACTER" ) ?
        (
            table.Name ~ " " ~ ( table.RowIndex + 1 ) ~ "/" ~ table.RowCount ~
            " :  " ~ row.FirstName ~ " " ~ row.LastName ~
            " (" ~ ( Replace ( row.Race ).UpperCase "HOBBIT" "Hobbit" ) ~ ")\n\n" ~
            row.Description ~ "\n\n" ~
            row.Comment ~ "\n\n---\n"
        )
    ) ~ "\n" ~
    ( !true ) ~ "\n" ~
    ( true & true & false ) ~ "\n" ~
    ( false | false | true ) ~ "\n\n" ~
    ( 1 < 2 ) ~ "\n" ~
    ( 1 <= 2 ) ~ "\n" ~
    ( 1 != 2 ) ~ "\n" ~
    ( 1 == 2 ) ~ "\n" ~
    ( 1 >= 2 ) ~ "\n" ~
    ( 1 > 2 ) ~ "\n\n" ~
    ( "a" < "b" ) ~ "\n" ~
    ( "a" <= "b" ) ~ "\n" ~
    ( "a" != "b" ) ~ "\n" ~
    ( "a" == "b" ) ~ "\n" ~
    ( "a" >= "b" ) ~ "\n" ~
    ( "a" > "b" ) ~ "\n\n" ~
    ( ( 1 < 2 ) ? "then" ) ~ "\n" ~
    ( ( 1 < 2 ) ? "then" : "else" ) ~ "\n\n" ~
    ( 1 + 2 + 3 ) ~ "\n" ~
    ( 1 - 2 - 3 ) ~ "\n" ~
    ( 1 * 2 * 3 ) ~ "\n" ~
    ( 1 / 2 / 3 ) ~ "\n\n" ~
    ( "string" ~ 'string' ~ `string` ) ~ "\n\n---\n\n"
)
```

### Constants

```javascript
false
true

123

123.456

"this is
a string"

'this is
a string'

`this is
a string`
```

### Variables

```javascript
table.Name
table.RowIndex
table.RowCount

row.<column name>
prior_row.<column name>
next_row.<column name>

row_<index>.<column name>
prior_row_<offset>.<column name>
next_row_<offset>.<column name>
```

### Operators

```javascript
( !true )
( true & true & false )
( false | false | true )
( 1 < 2 )
( 1 <= 2 )
( 1 != 2 )
( 1 == 2 )
( 1 >= 2 )
( 1 > 2 )
( "a" < "b" )
( "a" <= "b" )
( "a" != "b" )
( "a" == "b" )
( "a" >= "b" )
( "a" > "b" )
( ( 1 < 2 ) ? "then" )
( ( 1 < 2 ) ? "then" : "else" )
( 1 + 2 + 3 )
( 1 - 2 - 3 )
( 1 * 2 * 3 )
( 1 / 2 / 3 )
( "string" ~ 'string' ~ `string` )
```

### Methods

```javascript
value.Boolean
value.Number
value.String
value.Strip
value.StripLeft
value.StripRight
value.MinorCase
value.MajorCase
value.UpperCase
value.LowerCase
value.PascalCase
value.CamelCase
value.SnakeCase
value.SlugCase
value.Basil
value.Csv
```

### Functions

```javascript
( Contains "abcde" "bcd" )
( HasPrefix "abcde" "abc" )
( HasSuffix "abcde" "def" )
( Replace "abcde abcde" "bcd" "xyz" )
```

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 switch.d
```

## Command line

```
switch [options]
```

### Options

```
--read-sql <data file path> : read an SQL data file
--read-csv <data file path> <table name> : read a CSV data file
--write-bd <data file path> : write a Basil data file
--write-csv <data file path> <table name> : write a CSV data file
--write-txt <template file path> <output file path> : write a text file
```

### Examples

```bash
switch --read-sql blog.sql --write-bd blog.bd
```

Reads an SQL data file and writes a Basil data file.

```bash
switch --read-sql blog.sql --write-csv blog_article.csv ARTICLE --write-csv blog_comment.csv COMMENT
```

Reads an SQL data file and writes CSV data files.

```bash
switch --read-csv character.csv --write-bd character.bd
```

Reads a CSV data file and writes a Basil data file.

```bash
switch --read-csv character.csv --write-txt character.txt character.st
```

Reads a CSV data file and writes a text file.

## Limitations

*   Operators are applied without precedence.

## Version

0.1

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
