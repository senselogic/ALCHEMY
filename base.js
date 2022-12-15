function PrintLine( text )
{
    system.PrintLine( text );
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

function GetLowerCaseText( text )
{
    return system.GetLowerCaseText( text );
}

function GetUpperCaseText( text )
{
    return system.GetUpperCaseText( text );
}

function GetSlugCaseText( text )
{
    return system.GetSlugCaseText( text );
}

function GetSnakeCaseText( text )
{
    return system.GetSnakeCaseText( text );
}

function GetBasilText( text )
{
    return system.GetBasilText( text );
}

function GetCsvText( text )
{
    return system.GetCsvText( text );
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

