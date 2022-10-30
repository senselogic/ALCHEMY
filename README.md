![](https://github.com/senselogic/BASALT/blob/master/LOGO/basalt.png)

# Basalt

Database converter.

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
--read-csv <file path> : read a CSV data file
--read-sql <file path> : read an SQL data file
--write-bd <file path> : write a Basil data file
```

### Examples

```bash
basalt --read-csv character.csv --write-bd character.bd
```

Reads a CSV data file and writes a Basil data file.

```bash
basalt --read-sql blog.sql --write-bd blog.bd
```

Reads an SQL data file and writes a Basil data file.

## Version

0.1

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
