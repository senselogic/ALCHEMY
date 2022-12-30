![](https://github.com/senselogic/ALCHEMY/blob/master/LOGO/alchemy.png)

# Alchemy

Database converter.

## Import formats

*   SQL
*   CSV

## Export formats

*   Basil
*   CSV
*   Text

## Scripting

### Sample

Data processing scripts can be defined using a JavaScript-like syntax.

```javascript
let file_text = "";

for ( let table_index = 0;
      table_index < schema.TableCount;
      ++table_index )
{
    let table = schema.TableArray[ table_index ];

    if ( table.Name == "CHARACTER" )
    {
        for ( let row_index = 0;
              row_index < table.RowCount;
              ++row_index )
        {
            let row = table.RowArray[ row_index ];
            let next_row = table.GetRow( row_index + 1 );

            if ( row_index == 0 )
            {
                file_text +=
                    "CHARACTER\n\n    Id Slug FirstName LastName Description Race Comment\n";
            }

            let slug = GetSlugCaseText( row.GetValue( "FirstName" ) + "-" + row.GetValue( "LastName" ) + "-character" );

            file_text +=
                "\n"
                + "        %" + slug + "\n"
                + "             ~ " + slug + "\n"
                + "             ~ " + GetBasilText( row.GetValue( "FirstName" ) ) + "\n"
                + "             ~ " + GetBasilText( row.GetValue( "LastName" ) ) + "\n"
                + "             ~ " + GetBasilText( row.GetValue( "Description" ) ) + "\n"
                + "             ~ " + GetBasilText( row.GetValue( "Comment" ) ) + "\n";
        }
    }
}

WriteText( "character_js.bd", file_text );
```

### Classes

```javascript
ROW

    ColumnCount
    NameArray
    ValueArray

    AddColumn( name, value )
    GetValue( name )

TABLE

    Name
    RowCount
    RowArray
    DefaultRow
    ColumnCount
    ColumnNameArray

    AddRow( row )
    GetRow( row_index )

SCHEMA

    TableCount
    TableArray

    AddTable( table )
```

### Functions

```javascript
PrintLine( text )
GetInteger( text )
GetReal( text )
ContainsText( text, searched_text )
HasPrefix( text, prefix )
HasSuffix( text, suffix )
GetPrefix( text, separator )
GetSuffix( text, separator )
RemovePrefix( text, prefix )
RemoveSuffix( text, suffix )
ReplacePrefix( text, old_prefix, new_prefix )
ReplaceSuffix( text, old_suffix, new_suffix )
ReplaceText( text, old_text, new_text )
GetStrippedText( text )
GetLeftStrippedText( text )
GetRightStrippedText( text )
GetMinorCaseText( text )
GetMajorCaseText( text )
GetLowerCaseText( text )
GetUpperCaseText( text )
GetPascalCaseText( text )
GetCamelCaseText( text )
GetSnakeCaseText( text )
GetSlugCaseText( text )
GetBasilText( text )
GetCsvText( text )
ReadText( file_path )
WriteText( file_path, text )
```

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 alchemy.d
```

## Command line

```
alchemy [options]
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
alchemy --read-sql blog.sql --write-bd blog.bd
```

Reads an SQL data file and writes a Basil data file.

```bash
alchemy --read-sql blog.sql --write-csv blog_article.csv ARTICLE --write-csv blog_comment.csv COMMENT
```

Reads an SQL data file and writes CSV data files.

```bash
alchemy --read-csv character.csv --write-bd character.bd
```

Reads a CSV data file and writes a Basil data file.

```bash
alchemy --read-csv character.csv --write-txt character.txt character.st
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
