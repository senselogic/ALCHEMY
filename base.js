function PrintLine( text )
{
    system.PrintLine( text );
};

function Replace( text, old_text, new_text )
{
    return system.ReplaceText( text, old_text, new_text );
}

function GetUpperCase( text )
{
    return system.GetUpperCaseText( text );
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

ROW.prototype.Get = function( name )
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
};

function TABLE( name )
{
    this.Name = name;
    this.RowCount = 0;
    this.RowArray = [];
}

TABLE.prototype.AddRow = function( row )
{
    this.RowCount++;

    return this.RowArray.push( row );
};

TABLE.prototype.Get = function( row_index )
{
    return this.RowArray[ row_index ];
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

SCHEMA.prototype.Get = function( table_index )
{
    return this.TableArray[ table_index ];
};

