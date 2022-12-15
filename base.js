function PrintLine( text )
{
    system.PrintLine( text );
}

function GetInteger( text )
{
    return system.GetInteger( text );
}

function GetReal( text )
{
    return system.GetReal( text );
}

function ContainsText( text, searched_text )
{
    return system.ContainsText( text, searched_text );
}

function HasPrefix( text, prefix )
{
    return system.HasPrefix( text, prefix );
}

function HasSuffix( text, suffix )
{
    return system.HasSuffix( text, suffix );
}

function GetPrefix( text, separator )
{
    return system.GetPrefix( text, separator );
}

function GetSuffix( text, separator )
{
    return system.GetSuffix( text, separator );
}

function RemovePrefix( text, prefix )
{
    return system.RemovePrefix( text, prefix );
}

function RemoveSuffix( text, suffix )
{
    return system.RemoveSuffix( text, suffix );
}

function ReplacePrefix( text, old_prefix, new_prefix )
{
    return system.ReplacePrefix( text, old_prefix, new_prefix );
}

function ReplaceSuffix( text, old_suffix, new_suffix )
{
    return system.ReplaceSuffix( text, old_suffix, new_suffix );
}

function ReplaceText( text, old_text, new_text )
{
    return system.ReplaceText( text, old_text, new_text );
}

function GetStrippedText( text )
{
    return system.GetStrippedText( text );
}

function GetLeftStrippedText( text )
{
    return system.GetLeftStrippedText( text );
}

function GetRightStrippedText( text )
{
    return system.GetRightStrippedText( text );
}

function GetMinorCaseText( text )
{
    return system.GetMinorCaseText( text );
}

function GetMajorCaseText( text )
{
    return system.GetMajorCaseText( text );
}

function GetLowerCaseText( text )
{
    return system.GetLowerCaseText( text );
}

function GetUpperCaseText( text )
{
    return system.GetUpperCaseText( text );
}

function GetPascalCaseText( text )
{
    return system.GetPascalCaseText( text );
}

function GetCamelCaseText( text )
{
    return system.GetCamelCaseText( text );
}

function GetSnakeCaseText( text )
{
    return system.GetSnakeCaseText( text );
}

function GetSlugCaseText( text )
{
    return system.GetSlugCaseText( text );
}

function GetBasilText( text )
{
    return system.GetBasilText( text );
}

function GetCsvText( text )
{
    return system.GetCsvText( text );
}

function ReadText( file_path )
{
    return system.ReadText( file_path );
}

function WriteText( file_path, file_text )
{
    system.WriteText( file_path, file_text );
}

function ROW()
{
    this.ColumnCount = 0;
    this.NameArray = [];
    this.ValueArray = [];
}

ROW.prototype.AddColumn = function( name, value )
{
    this.ColumnCount++;
    this.NameArray.push( name );
    this.ValueArray.push( value );
};

ROW.prototype.GetValue = function( name )
{
    for ( let column_index = 0;
          column_index < this.ColumnCount;
          ++column_index )
    {
        if ( this.NameArray[ column_index ] == name )
        {
            return this.ValueArray[ column_index ];
        }
    }

    PrintLine( "Column not found : " + name );

    return "";
};

function TABLE( name )
{
    this.Name = name;
    this.RowCount = 0;
    this.RowArray = [];
    this.DefaultRow = new ROW();
    this.ColumnCount = 0;
    this.ColumnNameArray = [];
}

TABLE.prototype.AddRow = function( row )
{
    this.RowCount++;

    if ( this.ColumnCount == 0
         && row.ColumnCount > 0 )
    {
        this.ColumnCount = row.ColumnCount;

        for ( let column_index = 0;
              column_index < row.ColumnCount;
              ++column_index )
        {
            this.DefaultRow.AddColumn( row.NameArray[ column_index ], "" );
            this.ColumnNameArray.push( row.NameArray[ column_index ] );
        }
    }

    return this.RowArray.push( row );
};

TABLE.prototype.GetRow = function( row_index )
{
    if ( row_index >= 0
         && row_index < this.RowCount )
    {
        return this.RowArray[ row_index ];
    }
    else
    {
        return this.DefaultRow;
    }
};

function SCHEMA()
{
    this.TableCount = 0;
    this.TableArray = [];
}

SCHEMA.prototype.AddTable = function( table )
{
    this.TableCount++;
    this.TableArray.push( table );
};

