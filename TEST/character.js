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

            file_text
                += table.Name + " " + ( row_index + 1 ) + "/" + table.RowCount
                   + " :  " + row.Get( "FirstName" ) + " " + row.Get( "LastName" )
                   + " (" + GetUpperCase( Replace( row.Get( "Race" ), "HOBBIT", "Hobbit" ) ) + ")\n\n"
                   + row.Get( "Description" ) + "\n\n"
                   + row.Get( "Comment" ) + "\n\n"
                   + "---\n";
        }
    }
}

WriteText( "character.txt", file_text );
