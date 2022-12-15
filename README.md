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

## Scripting format

*   JavaScript subset

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
--write-js <script file path> : run a JS script
--run-js <script file path> : run a JS script
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
