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
import std.algorithm : countUntil;
import std.conv : to;
import std.file : readText, write;
import std.stdio : writeln;
import std.string : endsWith, indexOf, join, replace, split, startsWith, toLower;

// -- TYPES

enum VALUE_TYPE
{
    // -- CONSTANTS

    Boolean,
    Number,
    String,
    Identifier,
    Operator,
    Character
}

// ~~

struct VALUE
{
    // -- ATTRIBUTES

    VALUE_TYPE
        Type;
    string
        Text;
    double
        Number;

    // -- INQUIRIES

    bool IsBoolean(
        )
    {
        return Type == VALUE_TYPE.Boolean;
    }

    // ~~

    bool IsBoolean(
        string text
        )
    {
        return
            Type == VALUE_TYPE.Boolean
            && Text == text;
    }

    // ~~

    bool IsTrue(
        )
    {
        return
            Text != "false"
            && Text != "0"
            && Text != "0.0"
            && Text != "";
    }

    // ~~

    bool IsNumber(
        )
    {
        return Type == VALUE_TYPE.Number;
    }

    // ~~

    bool IsNumber(
        string text
        )
    {
        return
            Type == VALUE_TYPE.Number
            && Text == text;
    }

    // ~~

    bool IsString(
        )
    {
        return Type == VALUE_TYPE.String;
    }

    // ~~

    bool IsString(
        string text
        )
    {
        return
            Type == VALUE_TYPE.String
            && Text == text;
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

    bool IsBooleanIdentifier(
        )
    {
        return
            Type == VALUE_TYPE.Identifier
            && ( Text == "false"
                 || Text == "true" );
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

    bool IsOperator(
        )
    {
        return Type == VALUE_TYPE.Operator;
    }

    // ~~

    bool IsOperator(
        string text
        )
    {
        return
            Type == VALUE_TYPE.Operator
            && Text == text;
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

    bool IsArgument(
        )
    {
        return
            Type == VALUE_TYPE.Boolean
            || Type == VALUE_TYPE.Number
            || Type == VALUE_TYPE.String;
    }

    // ~~

    long GetComparison(
        VALUE value
        )
    {
        if ( Type == VALUE_TYPE.Number
             && value.Type == VALUE_TYPE.Number )
        {
            if ( Number < value.Number )
            {
                return -1;
            }
            else if ( Number > value.Number )
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            if ( Text < value.Text )
            {
                return -1;
            }
            else if ( Text > value.Text )
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
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

    // ~~

    void Print(
        long value_index,
        string value_index_prefix = ""
        )
    {
        writeln( "[", value_index_prefix, value_index, "] ", Type, " : `", Text, "`" );
    }

    // -- OPERATIONS

    void SetBoolean(
        string text
        )
    {
        Type = VALUE_TYPE.Boolean;
        Text = text;
        Number = 0.0;
    }

    // ~~

    void SetBoolean(
        bool boolean
        )
    {
        Type = VALUE_TYPE.Boolean;
        Text = boolean ? "true" : "false";
        Number = 0.0;
    }

    // ~~

    void SetNumber(
        string text
        )
    {
        Type = VALUE_TYPE.Number;
        Text = text;
        Number = 0.0;
    }

    // ~~

    void SetNumber(
        long number
        )
    {
        Type = VALUE_TYPE.Number;
        Text = number.to!string();
        Number = number.to!double();
    }

    // ~~

    void SetNumber(
        double number
        )
    {
        Type = VALUE_TYPE.Number;
        Text = number.to!string();
        Number = number;
    }

    // ~~

    void SetString(
        string text
        )
    {
        Type = VALUE_TYPE.String;
        Text = text;
        Number = 0.0;
    }

    // ~~

    void SetIdentifier(
        string text
        )
    {
        Type = VALUE_TYPE.Identifier;
        Text = text;
        Number = 0.0;
    }

    // ~~

    void SetOperator(
        string text
        )
    {
        Type = VALUE_TYPE.Operator;
        Text = text;
        Number = 0.0;
    }

    // ~~

    void SetCharacter(
        string text
        )
    {
        Type = VALUE_TYPE.Character;
        Text = text;
        Number = 0.0;
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

    // -- INQUIRIES

    COLUMN FindColumn(
        string column_name
        )
    {
        foreach ( column; ColumnArray )
        {
            if ( column.Name == column_name )
            {
                return column;
            }
        }

        return null;
    }

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

    string GetCell(
        string[][] cell_array_array,
        long row_index,
        long row_cell_index
        )
    {
        if ( row_index < cell_array_array.length
             && row_cell_index < cell_array_array[ row_index ].length )
        {
            return cell_array_array[ row_index ][ row_cell_index ];
        }
        else
        {
            return "";
        }
    }

    // ~~

    void SetCell(
        string[][] cell_array_array,
        long row_index,
        long row_cell_index,
        string value
        )
    {
        if ( row_index >= cell_array_array.length )
        {
            cell_array_array.length = row_index + 1;
        }

        if ( row_cell_index >= cell_array_array[ row_index ].length )
        {
            cell_array_array[ row_index ].length = row_cell_index + 1;
        }

        cell_array_array[ row_index ][ row_cell_index ] = value;
    }

    // ~~

    void MergeCsvCells(
        string[][] cell_array_array
        )
    {
        long
            next_cell_index,
            prior_cell_index;
        string
            prior_cell;
        string[]
            part_array;

        if ( cell_array_array.length > 0 )
        {
            for ( next_cell_index = 0;
                  next_cell_index < cell_array_array[ 0 ].length;
                  ++next_cell_index )
            {
                part_array = cell_array_array[ 0 ][ next_cell_index ].split( '+' );

                if ( part_array.length == 2 )
                {
                    prior_cell_index = cell_array_array[ 0 ].countUntil( part_array[ 0 ] );

                    if ( prior_cell_index < 0 )
                    {
                        Abort( "Invalid column name : " ~ part_array[ 0 ] );
                    }

                    foreach ( row_index, cell_array; cell_array_array )
                    {
                        if ( row_index > 0 )
                        {
                            prior_cell
                                = GetCell( cell_array_array, row_index, prior_cell_index )
                                  ~ part_array[ 1 ]
                                  ~ GetCell( cell_array_array, row_index, next_cell_index );

                            SetCell(
                                cell_array_array,
                                row_index,
                                prior_cell_index,
                                prior_cell
                                );

                            SetCell( cell_array_array, row_index, next_cell_index, "" );
                        }
                    }

                    cell_array_array[ 0 ][ next_cell_index ] = "";
                }
            }
        }
    }

    // ~~

    void ParseCsvCells(
        string[][] cell_array_array,
        string table_name
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

        table = GetTable( table_name );

        foreach ( row_index, row_cell_array; cell_array_array )
        {
            if ( row_index == 0 )
            {
                table_column_name_array.length = row_cell_array.length;
                table_column_cell_index_array.length = row_cell_array.length;

                foreach ( row_cell_index, row_cell; row_cell_array )
                {
                    part_array = row_cell.split( '#' );

                    if ( part_array.length == 2 )
                    {
                        cell_column_name = part_array[ 0 ];
                        cell_column_index = part_array[ 1 ].to!int() - 1;

                        if ( cell_column_index >= 0
                             && cell_column_index < table_column_name_array.length )
                        {
                            table_column_name_array[ cell_column_index ] = cell_column_name;
                            table_column_cell_index_array[ cell_column_index ] = row_cell_index;
                        }
                        else
                        {
                            Abort( "Invalid column number : " ~ row_cell );
                        }
                    }
                    else if ( row_cell != "" )
                    {
                        remaining_column_name_array ~= row_cell;
                        remaining_column_cell_index_array ~= row_cell_index;
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
                    table_column_cell_index = table_column_cell_index_array[ table_column_index ];

                    if ( table_column_name != "" )
                    {
                        table.GetColumn( table_column_name ).CellIndex = table_column_cell_index;
                    }
                }
            }
            else
            {
                foreach ( table_column; table.ColumnArray )
                {
                    table_column_cell_index = table_column.CellIndex;

                    if ( table_column_cell_index >= 0
                         && table_column_cell_index < row_cell_array.length )
                    {
                        table_column_value.SetString( row_cell_array[ table_column_cell_index ] );
                    }
                    else
                    {
                        table_column_value.SetString( "" );
                    }

                    table_column.ValueArray ~= table_column_value;
                }

                ++table.RowCount;
            }
        }
    }

    // ~~

    void ParseCsvText(
        string text,
        string table_name
        )
    {
        bool
            character_is_quoted,
            character_starts_row,
            character_starts_cell;
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
                        cell_array_array[ $ - 1 ][ $ - 1 ] ~= character;
                        ++character_index;

                    }
                    else
                    {
                        character_is_quoted = false;
                    }
                }
                else
                {
                    cell_array_array[ $ - 1 ][ $ - 1 ] ~= character;
                }
            }
            else if ( character == CellDelimiterCharacter )
            {
                cell_array_array[ $ - 1 ] ~= "";
                character_starts_cell = true;
            }
            else if ( character == RowDelimiterCharacter )
            {
                character_starts_row = true;
            }
            else
            {
                if ( character_starts_row )
                {
                    cell_array_array ~= null;
                    cell_array_array[ $ - 1 ] ~= "";
                }

                if ( cell_array_array[ $ - 1 ][ $ - 1 ] == ""
                     && character == StringDelimiterCharacter )
                {
                    character_is_quoted = true;
                }
                else
                {
                    cell_array_array[ $ - 1 ][ $ - 1 ] ~= character;
                }

                character_starts_row = false;
                character_starts_cell = false;
            }
        }

        MergeCsvCells( cell_array_array );
        ParseCsvCells( cell_array_array, table_name );
    }

    // ~~

    void ReadCsvFile(
        string file_path,
        string table_name
        )
    {
        ParseCsvText( file_path.ReadText(), table_name );
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
        string
            value_text;
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
                value_text = "";

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
                            value_text ~= 0;
                        }
                        else if ( next_character == 'b' )
                        {
                            value_text ~= '\b';
                        }
                        else if ( next_character == 'n' )
                        {
                            value_text ~= '\n';
                        }
                        else if ( next_character == 'r' )
                        {
                            value_text ~= '\r';
                        }
                        else if ( next_character == 't' )
                        {
                            value_text ~= '\t';
                        }
                        else if ( next_character == 'Z' )
                        {
                            value_text ~= 26;
                        }
                        else
                        {
                            value_text ~= next_character;
                        }

                        character_index += 2;
                    }
                    else
                    {
                        value.Text ~= character;

                        ++character_index;
                    }
                }

                value.SetString( value_text );
                value_array ~= value;
            }
            else if ( character == '`' )
            {
                value_text = "";

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
                        value_text ~= character;

                        ++character_index;
                    }
                }

                value.SetIdentifier( value_text );
                value_array ~= value;
            }
            else if ( IsAlphabeticalCharacter( character ) )
            {
                value_text = "" ~ character;

                while ( character_index + 1 < text.length )
                {
                    next_character = text[ character_index + 1 ];

                    if ( IsIdentifierCharacter( next_character ) )
                    {
                        value_text ~= next_character;

                        ++character_index;
                    }
                    else
                    {
                        break;
                    }
                }

                value.SetIdentifier( value_text );
                value_array ~= value;
            }
            else if ( character == '-'
                      || IsDecimalCharacter( character ) )
            {
                value_text = "" ~ character;

                while ( character_index + 1 < text.length )
                {
                    next_character = text[ character_index + 1 ];

                    if ( IsNumberCharacter( next_character ) )
                    {
                        value_text ~= next_character;

                        ++character_index;
                    }
                    else
                    {
                        break;
                    }
                }

                value.SetNumber( value_text );
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
                    value.SetCharacter( "" ~ character );
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

    // ~~

    VALUE[] GetTemplateValueArray(
        string text
        )
    {
        char
            character,
            next_character,
            quote_character;
        long
            character_index;
        string
            value_text;
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

            if ( "\"'`´".indexOf( character ) >= 0 )
            {
                quote_character = character;
                value_text = "";
                ++character_index;

                while ( character_index < text.length )
                {
                    character = text[ character_index ];
                    next_character = ( character_index + 1 < text.length ) ? text[ character_index + 1 ] : 0;

                    if ( character == quote_character )
                    {
                        break;
                    }
                    else if ( character == '\\' )
                    {
                        if ( next_character == '0' )
                        {
                            value_text ~= 0;
                        }
                        else if ( next_character == 'b' )
                        {
                            value_text ~= '\b';
                        }
                        else if ( next_character == 'n' )
                        {
                            value_text ~= '\n';
                        }
                        else if ( next_character == 'r' )
                        {
                            value_text ~= '\r';
                        }
                        else if ( next_character == 't' )
                        {
                            value_text ~= '\t';
                        }
                        else
                        {
                            value_text ~= next_character;
                        }

                        character_index += 2;
                    }
                    else
                    {
                        value_text ~= character;

                        ++character_index;
                    }
                }

                value.SetString( value_text );
                value_array ~= value;
            }
            else if ( IsAlphabeticalCharacter( character ) )
            {
                value_text = "" ~ character;

                while ( character_index + 1 < text.length )
                {
                    next_character = text[ character_index + 1 ];

                    if ( IsIdentifierCharacter( next_character ) )
                    {
                        value_text ~= next_character;

                        ++character_index;
                    }
                    else
                    {
                        break;
                    }
                }

                if ( value.IsBooleanIdentifier() )
                {
                    value.SetBoolean( value_text );
                }
                else
                {
                    value.SetIdentifier( value_text );
                }

                value_array ~= value;
            }
            else if ( ( character == '-'
                        && IsDecimalCharacter( next_character ) )
                      || IsDecimalCharacter( character ) )
            {
                value_text = "" ~ character;

                while ( character_index + 1 < text.length )
                {
                    next_character = text[ character_index + 1 ];

                    if ( IsNumberCharacter( next_character ) )
                    {
                        value_text ~= next_character;

                        ++character_index;
                    }
                    else
                    {
                        break;
                    }
                }

                value.SetNumber( value_text) ;
                value_array ~= value;
            }
            else if ( character != ' '
                      && character != '\n' )
            {
                if ( "!?:&|+-*/~<>=.".indexOf( character ) >= 0 )
                {
                    if ( ( character == '<' || character == '!' || character == '=' || character == '>' )
                         && next_character == '=' )
                    {
                        value.SetOperator( "" ~ character ~ next_character );

                        ++character_index;
                    }
                    else
                    {
                        value.SetOperator( "" ~ character );
                    }
                }
                else
                {
                    value.SetCharacter( "" ~ character );
                }

                value_array ~= value;
            }
        }

        return value_array;
    }

    // ~~

    void EvaluateProperties(
        ref VALUE[] result_value_array,
        TABLE table,
        long row_index
        )
    {
        long
            value_index;
        COLUMN
            column;
        VALUE
            property_value,
            variable_value;

        for ( value_index = 0;
              value_index + 2 < result_value_array.length;
              ++value_index )
        {
            if ( result_value_array[ value_index ].IsIdentifier()
                 && result_value_array[ value_index + 1 ].IsOperator( "." )
                 && result_value_array[ value_index + 2 ].IsIdentifier() )
            {
                variable_value = result_value_array[ value_index ];
                property_value = result_value_array[ value_index + 2 ];

                if ( variable_value.IsIdentifier( "table" ) )
                {
                    if ( property_value.IsIdentifier( "Name" ) )
                    {
                        result_value_array[ value_index ].SetString( table.Name );
                    }
                    else if ( property_value.IsIdentifier( "RowIndex" ) )
                    {
                        result_value_array[ value_index ].SetNumber( row_index );
                    }
                    else if ( property_value.IsIdentifier( "RowCount" ) )
                    {
                        result_value_array[ value_index ].SetNumber( table.RowCount );
                    }
                    else
                    {
                        Abort(
                            "Invalid property : ",
                            result_value_array,
                            value_index,
                            value_index + 3,
                            value_index,
                            value_index + 3
                            );
                    }

                    result_value_array
                        = result_value_array[ 0 .. value_index + 1 ]
                          ~ result_value_array[ value_index + 3 .. $ ];
                }
                else if ( variable_value.IsIdentifier( "row" ) )
                {
                    column = table.FindColumn( property_value.Text );

                    if ( column !is null )
                    {
                        result_value_array
                            = result_value_array[ 0 .. value_index ]
                              ~ column.ValueArray[ row_index ]
                              ~ result_value_array[ value_index + 3 .. $ ];
                    }
                    else
                    {
                        Abort(
                            "Invalid property : ",
                            result_value_array,
                            value_index,
                            value_index + 3,
                            value_index,
                            value_index + 3
                            );
                    }
                }
            }
        }
    }

    // ~~

    bool EvaluateOperators(
        ref VALUE[] result_value_array
        )
    {
        long
            first_argument_value_index,
            first_value_index,
            last_argument_value_index,
            last_value_index,
            operator_value_index;
        VALUE
            argument_value,
            operator_value,
            property_value,
            result_value;
        VALUE[]
            value_array;

        for ( first_value_index = 0;
              first_value_index + 2 < result_value_array.length;
              ++first_value_index )
        {
            if ( result_value_array[ first_value_index ].IsArgument()
                 && result_value_array[ first_value_index + 1 ].IsOperator( "." )
                 && result_value_array[ first_value_index + 2 ].IsIdentifier() )
            {
                value_array = result_value_array[ first_value_index .. first_value_index + 3 ];
                argument_value = value_array[ 0 ];
                property_value = value_array[ 2 ];

                if ( argument_value.IsString()
                     && property_value.IsIdentifier( "ToLowerCase" ) )
                {
                    result_value.SetString( argument_value.Text.toLower() );
                }
                else if ( argument_value.IsString()
                          && property_value.IsIdentifier( "ToUpperCase" ) )
                {
                    result_value.SetString( argument_value.Text.toLower() );
                }
                else if ( property_value.IsIdentifier( "ToBoolean" ) )
                {
                    result_value.SetBoolean( argument_value.IsTrue() );
                }
                else if ( property_value.IsIdentifier( "ToNumber" ) )
                {
                    result_value.SetNumber( argument_value.Text );
                }
                else if ( property_value.IsIdentifier( "ToString" ) )
                {
                    result_value.SetString( argument_value.Text );
                }
                else
                {
                    Abort(
                        "Invalid expression : ",
                        result_value_array,
                        first_value_index,
                        first_value_index + 3,
                        first_value_index,
                        first_value_index + 3
                        );
                }

                result_value_array
                    = result_value_array[ 0 .. first_value_index ]
                      ~ result_value
                      ~ result_value_array[ first_value_index + 3 .. $ ];

                return true;
            }
        }

        for ( first_value_index = 0;
              first_value_index < result_value_array.length;
              ++first_value_index )
        {
            if ( result_value_array[ first_value_index ].IsCharacter( "(" ) )
            {
                for ( last_value_index = first_value_index + 1;
                      last_value_index < result_value_array.length;
                      ++last_value_index )
                {
                    if ( result_value_array[ last_value_index ].IsCharacter( "(" ) )
                    {
                        first_value_index = last_value_index;
                    }
                    else if ( result_value_array[ last_value_index ].IsCharacter( ")" ) )
                    {
                        break;
                    }
                }

                if ( last_value_index < result_value_array.length )
                {
                    value_array = result_value_array[ first_value_index + 1 .. last_value_index ];

                    if ( value_array.length == 1
                         && value_array[ 0 ].IsArgument() )
                    {
                        result_value = value_array[ 0 ];
                    }
                    else if ( value_array.length == 2
                         && value_array[ 0 ].IsOperator( "!" )
                         && value_array[ 1 ].IsArgument() )
                    {
                        result_value.SetBoolean( !value_array[ 1 ].IsTrue() );
                    }
                    else if ( value_array.length == 3
                              && value_array[ 0 ].IsBoolean()
                              && value_array[ 1 ].IsOperator( "?" )
                              && value_array[ 2 ].IsArgument() )
                    {
                        if ( value_array[ 0 ].IsTrue() )
                        {
                            result_value = value_array[ 3 ];
                        }
                        else
                        {
                            result_value.SetString( "" );
                        }
                    }
                    else if ( value_array.length == 5
                              && value_array[ 0 ].IsBoolean()
                              && value_array[ 1 ].IsOperator( "?" )
                              && value_array[ 2 ].IsArgument()
                              && value_array[ 3 ].IsOperator( ":" )
                              && value_array[ 4 ].IsArgument() )
                    {
                        if ( value_array[ 0 ].IsTrue() )
                        {
                            result_value = value_array[ 2 ];
                        }
                        else
                        {
                            result_value = value_array[ 4 ];
                        }
                    }
                    else if ( value_array.length >= 3
                              && ( value_array.length & 1 ) == 1
                              && value_array[ 1 ].IsOperator() )
                    {
                        result_value = value_array[ 0 ];

                        for ( operator_value_index = 1;
                              operator_value_index + 1 < value_array.length;
                              operator_value_index += 2 )
                        {
                            operator_value = value_array[ operator_value_index ];
                            argument_value = value_array[ operator_value_index + 1 ];

                            if ( operator_value.IsOperator( "~" )
                                 && result_value.IsArgument()
                                 && argument_value.IsArgument() )
                            {
                                result_value.SetString( result_value.Text ~ argument_value.Text );
                            }
                            else if ( operator_value.IsOperator( "+" )
                                      && result_value.IsNumber()
                                      && argument_value.IsNumber() )
                            {
                                result_value.SetNumber( result_value.Number + argument_value.Number );
                            }
                            else if ( operator_value.IsOperator( "-" )
                                      && result_value.IsNumber()
                                      && argument_value.IsNumber() )
                            {
                                result_value.SetNumber( result_value.Number - argument_value.Number );
                            }
                            else if ( operator_value.IsOperator( "*" )
                                      && result_value.IsNumber()
                                      && argument_value.IsNumber() )
                            {
                                result_value.SetNumber( result_value.Number * argument_value.Number );
                            }
                            else if ( operator_value.IsOperator( "/" )
                                      && result_value.IsNumber()
                                      && argument_value.IsNumber() )
                            {
                                result_value.SetNumber( result_value.Number / argument_value.Number );
                            }
                            else if ( operator_value.IsOperator( "<" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument()
                                      && argument_value.Type == result_value.Type )
                            {
                                result_value.SetBoolean( result_value.GetComparison( argument_value ) < 0 );
                            }
                            else if ( operator_value.IsOperator( "<=" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument()
                                      && argument_value.Type == result_value.Type )
                            {
                                result_value.SetBoolean( result_value.GetComparison( argument_value ) <= 0 );
                            }
                            else if ( operator_value.IsOperator( "!=" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument()
                                      && argument_value.Type == result_value.Type )
                            {
                                result_value.SetBoolean( result_value.GetComparison( argument_value ) != 0 );
                            }
                            else if ( operator_value.IsOperator( "==" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument()
                                      && argument_value.Type == result_value.Type )
                            {
                                result_value.SetBoolean( result_value.GetComparison( argument_value ) == 0 );
                            }
                            else if ( operator_value.IsOperator( ">=" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument()
                                      && argument_value.Type == result_value.Type )
                            {
                                result_value.SetBoolean( result_value.GetComparison( argument_value ) >= 0 );
                            }
                            else if ( operator_value.IsOperator( ">" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument()
                                      && argument_value.Type == result_value.Type )
                            {
                                result_value.SetBoolean( result_value.GetComparison( argument_value ) > 0 );
                            }
                            else if ( operator_value.IsOperator( "&" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument() )
                            {
                                result_value.SetBoolean( result_value.IsTrue() && argument_value.IsTrue() );
                            }
                            else if ( operator_value.IsOperator( "|" )
                                      && result_value.IsArgument()
                                      && argument_value.IsArgument() )
                            {
                                result_value.SetBoolean( result_value.IsTrue() || argument_value.IsTrue() );
                            }
                            else
                            {
                                Abort(
                                    "Invalid expression : ",
                                    result_value_array,
                                    first_value_index,
                                    last_value_index + 1,
                                    first_value_index + operator_value_index + 1,
                                    first_value_index + operator_value_index + 3
                                    );
                            }
                        }
                    }

                    result_value_array
                        = result_value_array[ 0 .. first_value_index ]
                          ~ result_value
                          ~ result_value_array[ last_value_index + 1 .. $ ];

                    return true;
                }
            }
        }

        return false;
    }

    // ~~

    string GetProcessedText(
        string template_text
        )
    {
        string
            processed_text;
        VALUE[]
            result_value_array,
            template_value_array;

        template_value_array = GetTemplateValueArray( template_text );

        foreach ( table; TableArray )
        {
            foreach ( row_index; 0 .. table.RowCount )
            {
                result_value_array = template_value_array.dup();

                EvaluateProperties( result_value_array, table, row_index );

                while ( EvaluateOperators( result_value_array ) )
                {
                }

                if ( result_value_array.length != 1 )
                {
                    Abort( "Invalid expression value : " ~ template_text );
                }

                processed_text ~= result_value_array[ 0 ].Text;
            }
        }

        return processed_text;
    }

    // ~~

    void ProcessFile(
        string template_file_path,
        string file_path
        )
    {
        file_path.WriteText(
            GetProcessedText( template_file_path.ReadText() )
            );
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

void PrintValues(
    VALUE[] value_array,
    long first_value_index,
    long post_value_index,
    long error_first_value_index = -1,
    long error_post_value_index = -1
    )
{
    foreach ( value_index; first_value_index .. post_value_index )
    {
        if ( value_index >= error_first_value_index
             && value_index < error_post_value_index )
        {
            value_array[ value_index ].Print( value_index, "*" );
        }
        else
        {
            value_array[ value_index ].Print( value_index );
        }
    }
}

// ~~

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
    VALUE[] value_array,
    long first_value_index,
    long post_value_index,
    long error_first_value_index = -1,
    long error_post_value_index = -1
    )
{
    PrintError( message );
    PrintValues( value_array, first_value_index, post_value_index, error_first_value_index, error_post_value_index );

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
             && argument_count == 2
             && argument_array[ 0 ].endsWith( ".csv" ) )
        {
            Schema.ReadCsvFile( argument_array[ 0 ], argument_array[ 1 ] );
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
        else if ( option == "--process"
                  && argument_count == 2
                  && argument_array[ 0 ].endsWith( ".bt" ) )
        {
            Schema.ProcessFile( argument_array[ 0 ], argument_array[ 1 ] );
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
