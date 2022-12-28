let file_text = "";

for ( let table_index = 0;
      table_index < schema.TableCount;
      ++table_index )
{
    let table = schema.TableArray[ table_index ];

    if ( table.Name == "CHARACTER" )
    {
        file_text +=
            "CHARACTER\n\n    Id Slug FirstName LastName Description Race Comment\n";

        for ( let row_index = 0;
              row_index < table.RowCount;
              ++row_index )
        {
            let row = table.RowArray[ row_index ];
            let next_row = table.GetRow( row_index + 1 );
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
