/*
    This file is part of the Alchemy distribution.

    https://github.com/senselogic/ALCHEMY

    Copyright (C) 2017 Eric Pelzer (ecstatic.coder@gmail.com)

    Alchemy is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Alchemy is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Alchemy.  If not, see <http://www.gnu.org/licenses/>.
*/

// -- IMPORTS

import core.stdc.stdlib : exit;
import mildew.compiler : Compiler;
import mildew.environment : Environment;
import mildew.exceptions : ScriptCompileException, ScriptRuntimeException;
import mildew.interpreter : Interpreter;
import mildew.types : NativeFunctionError, ScriptAny, ScriptFunction;
import seed : Abort, ContainsText, GetBasilText, GetCamelCaseText, GetCsvText, GetExecutablePath, GetFileCaseText, GetInteger, GetJsonText, GetKebabCaseText, GetLeftStrippedText, GetLowerCaseText, GetMajorCaseText, GetMinorCaseText, GetPascalCaseText, GetPrefix, GetReal, GetRightStrippedText, GetSlugCaseText, GetSnakeCaseText, GetStrippedText, GetUpperCaseText, HasPrefix, HasSuffix, IsAlphabeticalCharacter, IsDecimalCharacter, IsIdentifierCharacter, IsNumberCharacter, PrintError, ReadText, RemovePrefix, RemoveSuffix, ReplacePrefix, ReplaceSuffix, ReplaceText, WriteText;
import std.algorithm : countUntil;
import std.conv : to;
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
        Type = VALUE_TYPE.String;
    string
        Text = "";
    double
        Number = 0.0;

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
        return Text.GetBasilText();
    }

    // ~~

    string GetCsvText(
        )
    {
        return Text.GetCsvText();
    }

    // ~~

    string GetJsText(
        )
    {
        return Text.GetJsonText();
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
        Number = text.GetReal();
    }

    // ~~

    void SetNumber(
        long number
        )
    {
        Type = VALUE_TYPE.Number;
        Text = number.to!string();
        Number = number.GetReal();
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

    // -- INQUIRIES

    VALUE GetValue(
        long value_index,
        VALUE default_value
        )
    {
        if ( value_index >= 0
             && value_index < ValueArray.length )
        {
            return ValueArray[ value_index ];
        }
        else
        {
            return default_value;
        }
    }

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

    // ~~

    string GetJsText(
        )
    {
        string
            text;
        VALUE
            default_value;

        text = "table = new TABLE( \"" ~ Name ~ "\" );\n";

        foreach ( row_index; 0 .. RowCount )
        {
            text ~= "row = new ROW();\n";

            foreach ( column; ColumnArray )
            {
                text ~= "row.AddColumn( \"" ~ column.Name ~ "\", " ~ column.GetValue( row_index, default_value ).GetJsText() ~ " );\n";
            }

            text ~= "table.AddRow( row );\n";
        }

        text ~= "schema.AddTable( table );\n";

        return text;
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

    TABLE FindTable(
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

        return null;
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

    void StripCsvCells(
        string[][] cell_array_array
        )
    {
        long
            cell_index;
        string
            cell;

        if ( cell_array_array.length > 0 )
        {
            for ( cell_index = 0;
                  cell_index < cell_array_array[ 0 ].length;
                  ++cell_index )
            {
                cell = cell_array_array[ 0 ][ cell_index ];

                if ( cell.startsWith( '!' ) )
                {
                    cell_array_array[ 0 ][ cell_index ] = cell[ 1 .. $ ];

                    foreach ( row_index, cell_array; cell_array_array )
                    {
                        if ( row_index > 0 )
                        {
                            cell = GetCell( cell_array_array, row_index, cell_index );
                            SetCell( cell_array_array, row_index, cell_index, cell.GetStrippedText() );
                        }
                    }
                }
                else if ( cell.startsWith( '<' ) )
                {
                    cell_array_array[ 0 ][ cell_index ] = cell[ 1 .. $ ];

                    foreach ( row_index, cell_array; cell_array_array )
                    {
                        if ( row_index > 0 )
                        {
                            cell = GetCell( cell_array_array, row_index, cell_index );
                            SetCell( cell_array_array, row_index, cell_index, cell.GetLeftStrippedText() );
                        }
                    }
                }
                else if ( cell.startsWith( '>' ) )
                {
                    cell_array_array[ 0 ][ cell_index ] = cell[ 1 .. $ ];

                    foreach ( row_index, cell_array; cell_array_array )
                    {
                        if ( row_index > 0 )
                        {
                            cell = GetCell( cell_array_array, row_index, cell_index );
                            SetCell( cell_array_array, row_index, cell_index, cell.GetRightStrippedText() );
                        }
                    }
                }
            }
        }
    }

    // ~~

    void MergeCsvCells(
        string[][] cell_array_array
        )
    {
        long
            cell_character_index,
            next_cell_index,
            prior_cell_index;
        string
            cell,
            column_name,
            column_suffix,
            prior_cell;

        if ( cell_array_array.length > 0 )
        {
            for ( next_cell_index = 0;
                  next_cell_index < cell_array_array[ 0 ].length;
                  ++next_cell_index )
            {
                cell = cell_array_array[ 0 ][ next_cell_index ];
                cell_character_index = cell.indexOf( '~' );

                if ( cell_character_index > 0 )
                {
                    column_name = cell[ 0 .. cell_character_index ];
                    column_suffix = cell[ cell_character_index + 1 .. $ ];

                    prior_cell_index = cell_array_array[ 0 ].countUntil( column_name );

                    if ( prior_cell_index < 0 )
                    {
                        Abort( "Invalid column name : " ~ column_name );
                    }

                    foreach ( row_index, cell_array; cell_array_array )
                    {
                        if ( row_index > 0 )
                        {
                            prior_cell
                                = GetCell( cell_array_array, row_index, prior_cell_index )
                                  ~ column_suffix
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

    string GetCsvText(
        string table_name
        )
    {
        string
            text;
        string[]
            column_text_array;
        TABLE
            table;
        VALUE
            default_value;

        table = FindTable( table_name );

        if ( table !is null )
        {
            foreach ( column; table.ColumnArray )
            {
                column_text_array ~= column.Name.GetCsvText();
            }

            text ~= column_text_array.join( ',' ) ~ "\n";

            foreach ( row_index; 0 .. table.RowCount )
            {
                column_text_array = null;

                foreach ( column; table.ColumnArray )
                {
                    column_text_array ~= column.GetValue( row_index, default_value ).GetCsvText();
                }

                text ~= column_text_array.join( ',' ) ~ "\n";
            }
        }
        else
        {
            Abort( "Invalid table name : " ~ table_name );
        }

        return text;
    }

    // ~~

    void WriteCsvFile(
        string file_path,
        string table_name
        )
    {
        file_path.WriteText( GetCsvText( table_name ) );
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
                        value_text ~= character;

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
                if ( character_starts_row )
                {
                    cell_array_array ~= null;
                    character_starts_row = false;
                    cell_array_array[ $ - 1 ] ~= "";
                }

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

        StripCsvCells( cell_array_array );
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

    string GetJsText(
        )
    {
        string
            text;

        text = "var row, schema, table;\nschema = new SCHEMA();\n";

        foreach ( table; TableArray )
        {
            text ~= table.GetJsText();
        }

        return text;
    }

    // ~~

    void PrintScript(
        string script_code
        )
    {
        foreach ( line_index, line; script_code.split( '\n' ) )
        {
            writeln( "[", line_index + 1, "] ", line );
        }
    }

    // ~~

    void WriteJsFile(
        string file_path
        )
    {
        string
            file_text;

        file_text
            = ReadText( GetExecutablePath( "base.js" ) )
              ~ GetJsText();

        WriteText( file_path, file_text );
    }

    // ~~

    void RunJsFile(
        string file_path
        )
    {
        string
            script_code;
        Interpreter
            interpreter;
        ScriptAny
            result;

        script_code
            = ReadText( GetExecutablePath( "base.js" ) )
              ~ GetJsText()
              ~ ReadText( file_path );

        try
        {
            interpreter = CreateInterpreter();
            result = interpreter.evaluate( script_code );
            interpreter.runVMFibers();
        }
        catch ( ScriptCompileException ex )
        {
            PrintScript( script_code );
            writeln( "\nIn file " ~ file_path );
            writeln( ex );
        }
        catch ( ScriptRuntimeException ex )
        {
            PrintScript( script_code );
            writeln( "\nIn file " ~ file_path );
            writeln( ex );

            if ( ex.thrownValue.type != ScriptAny.Type.UNDEFINED )
            {
                writeln( "Value thrown: ", ex.thrownValue );
            }
        }
        catch ( Compiler.UnimplementedException ex )
        {
            PrintScript( script_code );
            writeln( ex.msg );
        }
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

ScriptAny SystemPrintLine(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        writeln( argument_array[ 0 ].toString() );

        return ScriptAny.UNDEFINED;
    }
}

// ~~

ScriptAny SystemGetInteger(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetInteger( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetReal(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetReal( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemContainsText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( ContainsText( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() ) );
    }
}

// ~~

ScriptAny SystemHasPrefix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( HasPrefix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() ) );
    }
}

// ~~

ScriptAny SystemHasSuffix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( HasSuffix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetPrefix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetPrefix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetSuffix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetPrefix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() ) );
    }
}

// ~~

ScriptAny SystemRemovePrefix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( RemovePrefix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() ) );
    }
}

// ~~

ScriptAny SystemRemoveSuffix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( RemoveSuffix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() ) );
    }
}

// ~~

ScriptAny SystemReplacePrefix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 3 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( ReplacePrefix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString(), argument_array[ 2 ].toString() ) );
    }
}

// ~~

ScriptAny SystemReplaceSuffix(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 3 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( ReplaceSuffix( argument_array[ 0 ].toString(), argument_array[ 1 ].toString(), argument_array[ 2 ].toString() ) );
    }
}

// ~~

ScriptAny SystemReplaceText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 3 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( ReplaceText( argument_array[ 0 ].toString(), argument_array[ 1 ].toString(), argument_array[ 2 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetStrippedText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetStrippedText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetLeftStrippedText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetLeftStrippedText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetRightStrippedText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetRightStrippedText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetMinorCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetMinorCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetMajorCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetMajorCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetLowerCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetLowerCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetUpperCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetUpperCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetPascalCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetPascalCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetCamelCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetCamelCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetSnakeCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetSnakeCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetKebabCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetKebabCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetSlugCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetSlugCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetFileCaseText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetFileCaseText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetBasilText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetBasilText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemGetCsvText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( GetCsvText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemReadText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 1 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        return ScriptAny( ReadText( argument_array[ 0 ].toString() ) );
    }
}

// ~~

ScriptAny SystemWriteText(
    Environment environment,
    ScriptAny* self,
    ScriptAny[] argument_array,
    ref NativeFunctionError native_function_error
    )
{
    if ( argument_array.length != 2 )
    {
        native_function_error = NativeFunctionError.WRONG_NUMBER_OF_ARGS;

        return ScriptAny.UNDEFINED;
    }
    else
    {
        WriteText( argument_array[ 0 ].toString(), argument_array[ 1 ].toString() );

        return ScriptAny.UNDEFINED;
    }
}

// ~~

Interpreter CreateInterpreter(
    )
{
    Interpreter
        interpreter;

    interpreter = new Interpreter();

    interpreter.forceSetGlobal( "PrintLine", new ScriptFunction( "PrintLine", &SystemPrintLine ), false );
    interpreter.forceSetGlobal( "GetInteger", new ScriptFunction( "GetInteger", &SystemGetInteger ), false );
    interpreter.forceSetGlobal( "GetReal", new ScriptFunction( "GetReal", &SystemGetReal ), false );
    interpreter.forceSetGlobal( "ContainsText", new ScriptFunction( "ContainsText", &SystemContainsText ), false );
    interpreter.forceSetGlobal( "HasPrefix", new ScriptFunction( "HasPrefix", &SystemHasPrefix ), false );
    interpreter.forceSetGlobal( "HasSuffix", new ScriptFunction( "HasSuffix", &SystemHasSuffix ), false );
    interpreter.forceSetGlobal( "GetPrefix", new ScriptFunction( "GetPrefix", &SystemGetPrefix ), false );
    interpreter.forceSetGlobal( "GetSuffix", new ScriptFunction( "GetSuffix", &SystemGetSuffix ), false );
    interpreter.forceSetGlobal( "RemovePrefix", new ScriptFunction( "RemovePrefix", &SystemRemovePrefix ), false );
    interpreter.forceSetGlobal( "RemoveSuffix", new ScriptFunction( "RemoveSuffix", &SystemRemoveSuffix ), false );
    interpreter.forceSetGlobal( "ReplacePrefix", new ScriptFunction( "ReplacePrefix", &SystemReplacePrefix ), false );
    interpreter.forceSetGlobal( "ReplaceSuffix", new ScriptFunction( "ReplaceSuffix", &SystemReplaceSuffix ), false );
    interpreter.forceSetGlobal( "ReplaceText", new ScriptFunction( "ReplaceText", &SystemReplaceText ), false );
    interpreter.forceSetGlobal( "GetStrippedText", new ScriptFunction( "GetStrippedText", &SystemGetStrippedText ), false );
    interpreter.forceSetGlobal( "GetLeftStrippedText", new ScriptFunction( "GetLeftStrippedText", &SystemGetLeftStrippedText ), false );
    interpreter.forceSetGlobal( "GetRightStrippedText", new ScriptFunction( "GetRightStrippedText", &SystemGetRightStrippedText ), false );
    interpreter.forceSetGlobal( "GetMinorCaseText", new ScriptFunction( "GetMinorCaseText", &SystemGetMinorCaseText ), false );
    interpreter.forceSetGlobal( "GetMajorCaseText", new ScriptFunction( "GetMajorCaseText", &SystemGetMajorCaseText ), false );
    interpreter.forceSetGlobal( "GetLowerCaseText", new ScriptFunction( "GetLowerCaseText", &SystemGetLowerCaseText ), false );
    interpreter.forceSetGlobal( "GetUpperCaseText", new ScriptFunction( "GetUpperCaseText", &SystemGetUpperCaseText ), false );
    interpreter.forceSetGlobal( "GetPascalCaseText", new ScriptFunction( "GetPascalCaseText", &SystemGetPascalCaseText ), false );
    interpreter.forceSetGlobal( "GetCamelCaseText", new ScriptFunction( "GetCamelCaseText", &SystemGetCamelCaseText ), false );
    interpreter.forceSetGlobal( "GetSnakeCaseText", new ScriptFunction( "GetSnakeCaseText", &SystemGetSnakeCaseText ), false );
    interpreter.forceSetGlobal( "GetKebabCaseText", new ScriptFunction( "GetKebabCaseText", &SystemGetKebabCaseText ), false );
    interpreter.forceSetGlobal( "GetSlugCaseText", new ScriptFunction( "GetSlugCaseText", &SystemGetSlugCaseText ), false );
    interpreter.forceSetGlobal( "GetFileCaseText", new ScriptFunction( "GetFileCaseText", &SystemGetFileCaseText ), false );
    interpreter.forceSetGlobal( "GetBasilText", new ScriptFunction( "GetBasilText", &SystemGetBasilText ), false );
    interpreter.forceSetGlobal( "GetCsvText", new ScriptFunction( "GetCsvText", &SystemGetCsvText ), false );
    interpreter.forceSetGlobal( "ReadText", new ScriptFunction( "ReadText", &SystemReadText ), false );
    interpreter.forceSetGlobal( "WriteText", new ScriptFunction( "WriteText", &SystemWriteText ), false );

    return interpreter;
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

        if ( option == "--read-sql"
             && argument_count == 1
             && argument_array[ 0 ].endsWith( ".sql" ) )
        {
            Schema.ReadSqlFile( argument_array[ 0 ] );
        }
        else if ( option == "--read-csv"
             && argument_count == 2
             && argument_array[ 0 ].endsWith( ".csv" ) )
        {
            Schema.ReadCsvFile( argument_array[ 0 ], argument_array[ 1 ] );
        }
        else if ( option == "--write-bd"
                  && argument_count == 1
                  && argument_array[ 0 ].endsWith( ".bd" ) )
        {
            Schema.WriteBasilDataFile( argument_array[ 0 ] );
        }
        else if ( option == "--write-csv"
                  && argument_count == 2
                  && argument_array[ 0 ].endsWith( ".csv" ) )
        {
            Schema.WriteCsvFile( argument_array[ 0 ], argument_array[ 1 ] );
        }
        else if ( option == "--write-js"
                  && argument_count == 1
                  && argument_array[ 0 ].endsWith( ".js" ) )
        {
            Schema.WriteJsFile( argument_array[ 0 ] );
        }
        else if ( option == "--run-js"
                  && argument_count == 1
                  && argument_array[ 0 ].endsWith( ".js" ) )
        {
            Schema.RunJsFile( argument_array[ 0 ] );
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
        writeln( "    alchemy [options]" );
        writeln( "Options :" );
        writeln( "    --read-sql <data file path>" );
        writeln( "    --read-csv <data file path> <table name>" );
        writeln( "    --write-bd <data file path>" );
        writeln( "    --write-js <script file path>" );
        writeln( "    --run-js <script file path>" );
        writeln( "Examples :" );
        writeln( "    alchemy --read-sql blog.sql --write-bd blog.bd" );
        writeln( "    alchemy --read-sql blog.sql --write-csv blog.csv" );
        writeln( "    alchemy --read-csv character.csv --write-bd character.bd" );
        writeln( "    alchemy --read-csv character.csv --run-js character.js" );

        Abort( "Invalid arguments : " ~ argument_array.to!string() );
    }
}
