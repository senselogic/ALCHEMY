/*
    This file is part of the Basalt distribution.

    https://github.com/senselogic/BASALT

    Copyright (C) 2017 Eric Pelzer (ecstatic.coder@gmail.com)

    Basalt is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Basalt is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Basalt.  If not, see <http://www.gnu.org/licenses/>.
*/

// -- IMPORTS

import core.stdc.stdlib : exit;
import std.conv : to;
import std.file : readText, write;
import std.stdio : writeln;
import std.string : endsWith, join, replace, split, startsWith, toLower;

// -- TYPES

enum VALUE_TYPE
{
    // -- CONSTANTS

    String,
    Number,
    Identifier,
    Character
}

// ~~

struct VALUE
{
    // -- ATTRIBUTES

    string
        Text;
    VALUE_TYPE
        Type;

    // -- INQUIRIES

    bool IsString(
        )
    {
        return Type == VALUE_TYPE.String;
    }

    // ~~

    bool IsNumber(
        )
    {
        return Type == VALUE_TYPE.Number;
    }

    // ~~

    bool IsIdentifier(
        )
    {
        return Type == VALUE_TYPE.Identifier;
    }

    // ~~

    bool IsIdentifier(
        string text
        )
    {
        return
            Type == VALUE_TYPE.Identifier
            && Text == text;
    }

    // ~~

    bool IsLowercaseIdentifier(
        string text
        )
    {
        return
            Type == VALUE_TYPE.Identifier
            && Text.toLower() == text;
    }

    // ~~

    bool IsCharacter(
        )
    {
        return Type == VALUE_TYPE.Character;
    }

    // ~~

    bool IsCharacter(
        string text
        )
    {
        return
            Type == VALUE_TYPE.Character
            && Text == text;
    }

    // ~~

    string GetBasilText(
        )
    {
        return
            Text
                .replace( "\\", "\\\\" )
                .replace( "~", "\\~" )
                .replace( "^", "\\^" )
                .replace( "\n", "\\\\n" )
                .replace( "\r", "\\\\r" )
                .replace( "\t", "\\\\t" );
    }
}

// ~~

class COLUMN
{
    // -- ATTRIBUTES

    string
        Name,
        Definition;
    VALUE[]
        ValueArray;
    long
        CellIndex;

    // -- OPERATIONS

    void AddValue(
        VALUE value,
        long value_index
        )
    {
        writeln( "        " ~ Name ~ " : " ~ value.Text );

        if ( ValueArray.length == value_index )
        {
            ValueArray ~= value;
        }
        else
        {
            Abort( "Invalid value index for column " ~ Name ~ " : " ~ value_index.to!string() );
        }
    }
}

// ~~

class TABLE
{
    // -- ATTRIBUTES

    string
        Name;
    COLUMN[]
        ColumnArray;
    long
        RowCount;

    // -- OPERATIONS

    COLUMN GetColumn(
        string column_name
        )
    {
        COLUMN
            added_column;

        foreach ( column; ColumnArray )
        {
            if ( column.Name == column_name )
            {
                return column;
            }
        }

        added_column = new COLUMN();
        added_column.Name = column_name;

        ColumnArray ~= added_column;

        return added_column;
    }
}

// ~~

class SCHEMA
{
    // -- ATTRIBUTES

    TABLE[]
        TableArray;

    // -- INQUIRIES

    bool IsAlphabeticalCharacter(
        char character
        )
    {
        return
            ( character >= 'a' && character <= 'z' )
            || ( character >= 'A' && character <= 'Z' );
    }

    // ~~

    bool IsIdentifierCharacter(
        char character
        )
    {
        return
            ( character >= 'a' && character <= 'z' )
            || ( character >= 'A' && character <= 'Z' )
            || ( character >= '0' && character <= '9' )
            || character == '_';
    }

    // ~~

    bool IsDecimalCharacter(
        char character
        )
    {
        return ( character >= '0' && character <= '9' );
    }

    // ~~

    bool IsNumberCharacter(
        char character
        )
    {
        return
            ( character >= '0' && character <= '9' )
            || character == '.'
            || character == '-'
            || character == 'e'
            || character == 'E';
    }

    // ~~

    string[] GetColumnNameArray(
        COLUMN[] column_array
        )
    {
        string[]
            column_name_array;

        foreach ( column; column_array )
        {
            column_name_array ~= column.Name;
        }

        return column_name_array;
    }

    // ~~

    void WriteBasilDataFile(
        string file_path
        )
    {
        long
            column_index,
            row_index;
        string
            file_text;

        foreach ( table; TableArray )
        {
            if ( table.RowCount > 0 )
            {
                file_text ~= table.Name ~ "\n\n    ";

                for ( column_index = 0;
                      column_index < table.ColumnArray.length;
                      ++column_index )
                {
                    if ( column_index > 0 )
                    {
                        file_text ~= " ";
                    }

                    file_text ~= table.ColumnArray[ column_index ].Name;
                }

                file_text ~= "\n";

                for ( row_index = 0;
                      row_index < table.RowCount;
                      ++row_index )
                {
                    file_text ~= "\n";

                    for ( column_index = 0;
                          column_index < table.ColumnArray.length;
                          ++column_index )
                    {
                        if ( column_index == 0 )
                        {
                            file_text ~= "        ";
                        }
                        else
                        {
                            file_text ~= "            ~ ";
                        }

                        file_text
                            ~= table.ColumnArray[ column_index ].ValueArray[ row_index ].GetBasilText()
                               ~ "\n";
                    }
                }

                file_text ~= "\n";
            }
        }

        file_path.WriteText( file_text );
    }

    // -- OPERATIONS

    TABLE GetTable(
        string table_name
        )
    {
        TABLE
            added_table;

        foreach ( table; TableArray )
        {
            if ( table.Name == table_name )
            {
                return table;
            }
        }

        added_table = new TABLE();
        added_table.Name = table_name;

        TableArray ~= added_table;

        return added_table;
    }

    // ~~

    void ParseCsvCells(
        string[][] cell_array_array
        )
    {
        long
            cell_column_index,
            column_cell_index,
            remaining_column_cell_index,
            table_column_cell_index;
        long[]
            remaining_column_cell_index_array,
            table_column_cell_index_array;
        string
            cell_column_name;
        string[]
            part_array,
            remaining_column_name_array,
            table_column_name_array;
        TABLE
            table;
        VALUE
            table_column_value;

        table = GetTable( "TABLE" );

        foreach ( row_index, cell_array; cell_array_array )
        {
            if ( row_index == 0 )
            {
                table_column_name_array.length = cell_array.length;
                table_column_cell_index_array.length = cell_array.length;

                foreach ( cell_index, cell; cell_array )
                {
                    part_array = cell.split( '#' );

                    if ( part_array.length == 2 )
                    {
                        cell_column_name = part_array[ 0 ];
                        cell_column_index = part_array[ 1 ].to!int() - 1;

                        if ( cell_column_index >= 0
                             && cell_column_index < table_column_name_array.length )
                        {
                            table_column_name_array[ cell_column_index ] = cell_column_name;
                            table_column_cell_index_array[ cell_column_index ] = cell_index;
                        }
                        else
                        {
                            Abort( "Invalid column number : " ~ cell );
                        }
                    }
                    else if ( cell != "" )
                    {
                        remaining_column_name_array ~= cell;
                        remaining_column_cell_index_array ~= cell_index;
                    }
                }

                foreach ( remaining_column_index, remaining_column_name; remaining_column_name_array )
                {
                    remaining_column_cell_index = remaining_column_cell_index_array[ remaining_column_index ];

                    foreach ( table_column_index, table_column_name; table_column_name_array )
                    {
                        if ( table_column_name == "" )
                        {
                            table_column_name_array[ table_column_index ] = remaining_column_name;
                            table_column_cell_index_array[ table_column_index ] = remaining_column_cell_index;

                            break;
                        }
                    }
                }

                foreach ( table_column_index, table_column_name; table_column_name_array )
                {
                    if ( table_column_name != "" )
                    {
                        table.GetColumn( table_column_name ).CellIndex = table_column_cell_index_array[ table_column_index ];
                    }
                }
            }
            else
            {
                table_column_value.Type = VALUE_TYPE.String;

                foreach ( table_column; table.ColumnArray )
                {
                    table_column_cell_index = table_column.CellIndex;

                    if ( table_column_cell_index >= 0
                         && table_column_cell_index < cell_array.length )
                    {
                        table_column_value.Text = cell_array[ table_column_cell_index ];
                    }
                    else
                    {
                        table_column_value.Text = "";
                    }

                    table_column.ValueArray ~= table_column_value;
                }

                ++table.RowCount;
            }
        }
    }

    // ~~

    void ParseCsvText(
        string text
        )
    {
        bool
            character_starts_cell,
            character_is_quoted,
            character_starts_row;
        char
            character;
        long
            character_index;
        string[][]
            cell_array_array;

        text = text.replace( "\r", "" );

        character_starts_row = true;
        character_starts_cell = true;
        character_is_quoted = false;

        for ( character_index = 0;
              character_index < text.length;
              ++character_index )
        {
            character = text[ character_index ];

            if ( character_is_quoted )
            {
                if ( character == StringDelimiterCharacter )
                {
                    if ( character_index + 1 < text.length
                         && text[ character_index + 1 ] == StringDelimiterCharacter )
                    {
                        ++character_index;

                        cell_array_array[ $ - 1 ][ $ - 1 ] ~= character;
                    }
                    else
                    {
                        character_is_quoted = false;
                        character_starts_cell = true;
                    }
                }
                else
                {
                    cell_array_array[ $ - 1 ][ $ - 1 ] ~= character;
                }
            }
            else if ( character == CellDelimiterCharacter )
            {
                character_starts_cell = true;
            }
            else if ( character == RowDelimiterCharacter )
            {
                character_starts_cell = true;
                character_starts_row = true;
            }
            else
            {
                if ( character_starts_row )
                {
                    cell_array_array ~= null;
                }

                if ( character_starts_cell )
                {
                    cell_array_array[ $ - 1 ] ~= "";
                }

                if ( character_starts_cell
                     && character == StringDelimiterCharacter )
                {
                    character_is_quoted = true;
                }
                else
                {
                    cell_array_array[ $ - 1 ][ $ - 1 ] ~= character;
                }

                character_starts_cell = false;
                character_starts_row = false;
            }
        }

        ParseCsvCells( cell_array_array );
    }

    // ~~

    void ReadCsvFile(
        string file_path
        )
    {
        ParseCsvText( file_path.ReadText() );
    }

    // ~~

    /*
    INSERT INTO `blocks` (`id`, `idPage`, `idBlock`, `pageType`, `type`, `prior`) VALUES
    (3, 1, 3, 'page', 'text_and_image', 300000),
    ...
    */

    void ParseSqlStatement(
        VALUE[] value_array
        )
    {
        long
            column_index,
            value_index;
        COLUMN[]
            column_array;
        TABLE
            table;
        VALUE
            value;

        if ( value_array.length >= 10
             && value_array[ 0 ].IsLowercaseIdentifier( "insert" )
             && value_array[ 1 ].IsLowercaseIdentifier( "into" )
             && value_array[ 2 ].IsIdentifier()
             && value_array[ 3 ].IsCharacter( "(" )
             && value_array[ 4 ].IsIdentifier() )
        {
            table = GetTable( value_array[ 2 ].Text );

            writeln( "\n" ~ table.Name ~ "\n" );

            for ( value_index = 4;
                  value_index < value_array.length;
                  ++value_index )
            {
                value = value_array[ value_index ];

                if ( value.IsIdentifier() )
                {
                    column_array ~= table.GetColumn( value.Text );
                }
                else if ( value.IsCharacter( ")" ) )
                {
                    break;
                }
            }

            if ( value_index + 1 < value_array.length
                 && value_array[ value_index ].IsCharacter( ")" )
                 && value_array[ value_index + 1 ].IsLowercaseIdentifier( "values" ) )
            {
                writeln( "    " ~ GetColumnNameArray( column_array ).join( ' ' ) );

                for ( value_index += 2;
                      value_index < value_array.length;
                      ++value_index )
                {
                    value = value_array[ value_index ];

                    if ( value.IsCharacter( "(" ) )
                    {
                        writeln();

                        column_index = 0;
                    }
                    else if ( value.IsCharacter( ")" ) )
                    {
                        ++table.RowCount;
                    }
                    else if ( !value.IsCharacter( "," ) )
                    {
                        if ( column_index < column_array.length )
                        {
                            column_array[ column_index ].AddValue( value, table.RowCount );
                            ++column_index;
                        }
                        else
                        {
                            Abort( "Invalid value for table " ~ table.Name ~ " : " ~ value.Text );
                        }
                    }
                }
            }
        }
    }

    // ~~

    void ParseSqlText(
        string text
        )
    {
        char
            character,
            next_character;
        long
            character_index;
        VALUE
            value;
        VALUE[]
            value_array;

        text = text.replace( "\t", "    " ).replace( "\r", "" );

        for ( character_index = 0;
              character_index < text.length;
              ++character_index )
        {
            character = text[ character_index ];
            next_character = ( character_index + 1 < text.length ) ? text[ character_index + 1 ] : 0;

            if ( character == '/'
                 && next_character == '*' )
            {
                ++character_index;

                while ( character_index + 1 < text.length )
                {
                    if ( text[ character_index ] == '*'
                         && text[ character_index + 1 ] == '/' )
                    {
                        ++character_index;

                        break;
                    }
                    else
                    {
                        ++character_index;
                    }
                }
            }
            else if ( character == '-'
                      && next_character == '-' )
            {
                while ( character_index < text.length )
                {
                    if ( text[ character_index ] == '\n' )
                    {
                        break;
                    }
                    else
                    {
                        ++character_index;
                    }
                }
            }
            else if ( character == '\'' )
            {
                value.Text = "";
                value.Type = VALUE_TYPE.String;

                ++character_index;

                while ( character_index < text.length )
                {
                    character = text[ character_index ];
                    next_character = ( character_index + 1 < text.length ) ? text[ character_index + 1 ] : 0;

                    if ( character == '\'' )
                    {
                        break;
                    }
                    else if ( character == '\\' )
                    {
                        if ( next_character == '0' )
                        {
                            value.Text ~= 0;
                        }
                        else if ( next_character == 'b' )
                        {
                            value.Text ~= '\b';
                        }
                        else if ( next_character == 'n' )
                        {
                            value.Text ~= '\n';
                        }
                        else if ( next_character == 'r' )
                        {
                            value.Text ~= '\r';
                        }
                        else if ( next_character == 't' )
                        {
                            value.Text ~= '\t';
                        }
                        else if ( next_character == 'Z' )
                        {
                            value.Text ~= 26;
                        }
                        else
                        {
                            value.Text ~= next_character;
                        }

                        character_index += 2;
                    }
                    else
                    {
                        value.Text ~= character;

                        ++character_index;
                    }
                }

                value_array ~= value;
            }
            else if ( character == '`' )
            {
                value.Text = "";
                value.Type = VALUE_TYPE.Identifier;

                ++character_index;

                while ( character_index < text.length )
                {
                    character = text[ character_index ];

                    if ( character == '`' )
                    {
                        break;
                    }
                    else
                    {
                        value.Text ~= character;

                        ++character_index;
                    }
                }

                value_array ~= value;
            }
            else if ( IsAlphabeticalCharacter( character ) )
            {
                value.Text = "" ~ character;
                value.Type = VALUE_TYPE.Identifier;

                while ( character_index + 1 < text.length )
                {
                    next_character = text[ character_index + 1 ];

                    if ( IsIdentifierCharacter( next_character ) )
                    {
                        value.Text ~= next_character;

                        ++character_index;
                    }
                    else
                    {
                        break;
                    }
                }

                value_array ~= value;
            }
            else if ( character == '-'
                      || IsDecimalCharacter( character ) )
            {
                value.Text = "" ~ character;
                value.Type = VALUE_TYPE.Number;

                while ( character_index + 1 < text.length )
                {
                    next_character = text[ character_index + 1 ];

                    if ( IsNumberCharacter( next_character ) )
                    {
                        value.Text ~= next_character;

                        ++character_index;
                    }
                    else
                    {
                        break;
                    }
                }

                value_array ~= value;
            }
            else if ( character != ' '
                      && character != '\n' )
            {
                if ( character == ';' )
                {
                    if ( value_array.length > 0 )
                    {
                        ParseSqlStatement( value_array );
                        value_array = null;
                    }
                }
                else
                {
                    value.Text = "" ~ character;
                    value.Type = VALUE_TYPE.Character;
                    value_array ~= value;
                }
            }
        }
    }

    // ~~

    void ReadSqlFile(
        string file_path
        )
    {
        ParseSqlText( file_path.ReadText() );
    }
}

// -- VARIABLES

char
    StringDelimiterCharacter = '"',
    RowDelimiterCharacter = '\n',
    CellDelimiterCharacter = ',';
SCHEMA
    Schema;

// -- FUNCTIONS

void PrintError(
    string message
    )
{
    writeln( "*** ERROR : ", message );
}

// ~~

void Abort(
    string message
    )
{
    PrintError( message );

    exit( -1 );
}

// ~~

void Abort(
    string message,
    Exception exception
    )
{
    PrintError( message );
    PrintError( exception.msg );

    exit( -1 );
}

// ~~

string ReadText(
    string file_path
    )
{
    string
        file_text;

    writeln( "Reading file : ", file_path );

    try
    {
        file_text = file_path.readText();
    }
    catch ( Exception exception )
    {
        Abort( "Can't read file : " ~ file_path, exception );
    }

    return file_text;
}

// ~~

void WriteText(
    string file_path,
    string file_text
    )
{
    writeln( "Writing file : ", file_path );

    try
    {
        file_path.write( file_text );
    }
    catch ( Exception exception )
    {
        Abort( "Can't write file : " ~ file_path, exception );
    }
}

// ~~

void main(
    string[] argument_array
    )
{
    long
        argument_count;
    string
        option;

    Schema = new SCHEMA();

    argument_array = argument_array[ 1 .. $ ];

    while ( argument_array.length >= 1
            && argument_array[ 0 ].startsWith( "--" ) )
    {
        option = argument_array[ 0 ];

        argument_array = argument_array[ 1 .. $ ];
        argument_count = 0;

        while ( argument_count < argument_array.length
                && !argument_array[ argument_count ].startsWith( "--" ) )
        {
            ++argument_count;
        }

        if ( option == "--read-csv"
             && argument_count == 1
             && argument_array[ 0 ].endsWith( ".csv" ) )
        {
            Schema.ReadCsvFile( argument_array[ 0 ] );
        }
        else if ( option == "--read-sql"
                  && argument_count == 1
                  && argument_array[ 0 ].endsWith( ".sql" ) )
        {
            Schema.ReadSqlFile( argument_array[ 0 ] );
        }
        else if ( option == "--write-bd"
                  && argument_count == 1
                  && argument_array[ 0 ].endsWith( ".bd" ) )
        {
            Schema.WriteBasilDataFile( argument_array[ 0 ] );
        }
        else
        {
            Abort( "Invalid option : " ~ option );
        }

        argument_array = argument_array[ argument_count .. $ ];
    }

    if ( argument_array.length > 0 )
    {
        writeln( "Usage :" );
        writeln( "    basalt [options]" );
        writeln( "Options :" );
        writeln( "    --read-sql <file path>" );
        writeln( "    --write-bd <file path>" );
        writeln( "Examples :" );
        writeln( "    basalt --read-sql blog.sql --write-bd blog.bd" );

        Abort( "Invalid arguments : " ~ argument_array.to!string( ) );
    }
}
