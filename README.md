![](https://github.com/senselogic/BASALT/blob/master/LOGO/basalt.png)

# Basalt

Database converter.

### Template syntax

The table data can be converted to text files using Lisp-like templates which will be applied to each row of each table.

#### Constants

```javascript
false
true

123

123.456

`this is
a string`

"this is
a string"

'this is
a string'
```

#### Variables

```javascript
table.Name
table.RowIndex
table.RowCount
row.<column name>
```

#### Operators

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
( `string` ~ "string" ~ 'string' )
```

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 basalt.d
```

## Command line

```
basalt [options]
```

### Options

```
--read-csv <data file path> <table name> : read a CSV data file
--read-sql <data file path> : read an SQL data file
--write-bd <data file path> : write a Basil data file
--process <template file path> <output file path> : apply a template file
```

### Examples

```bash
basalt --read-csv character.csv --write-bd character.bd
```

Reads a CSV data file and writes a Basil data file.

```bash
basalt --read-csv player.csv --read-bt player.bt --write-txt player.txt
```

Reads a CSV data file and writes a Basil data file.

```bash
basalt --read-sql blog.sql --write-bd blog.bd
```

Reads an SQL data file and writes a Basil data file.

## Limitations

*   Template operators are applied in their declaration order.

## Version

0.1

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
