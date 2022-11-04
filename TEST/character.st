(
    (
        ( table.Name == "CHARACTER" ) ?
        (
            table.Name ~ " " ~ ( table.RowIndex + 1 ) ~ "/" ~ table.RowCount ~
            " :  " ~ row.FirstName ~ " " ~ row.LastName ~
            " (" ~ ( Replace ( row.Race ).UpperCase "HOBBIT" "Hobbit" ) ~ ")\n\n" ~
            row.Description ~ "\n\n" ~
            row.Comment ~ "\n\n---\n"
        )
    ) ~ "\n" ~
    ( !true ) ~ "\n" ~
    ( true & true & false ) ~ "\n" ~
    ( false | false | true ) ~ "\n\n" ~
    ( 1 < 2 ) ~ "\n" ~
    ( 1 <= 2 ) ~ "\n" ~
    ( 1 != 2 ) ~ "\n" ~
    ( 1 == 2 ) ~ "\n" ~
    ( 1 >= 2 ) ~ "\n" ~
    ( 1 > 2 ) ~ "\n\n" ~
    ( "a" < "b" ) ~ "\n" ~
    ( "a" <= "b" ) ~ "\n" ~
    ( "a" != "b" ) ~ "\n" ~
    ( "a" == "b" ) ~ "\n" ~
    ( "a" >= "b" ) ~ "\n" ~
    ( "a" > "b" ) ~ "\n\n" ~
    ( ( 1 < 2 ) ? "then" ) ~ "\n" ~
    ( ( 1 < 2 ) ? "then" : "else" ) ~ "\n\n" ~
    ( 1 + 2 + 3 ) ~ "\n" ~
    ( 1 - 2 - 3 ) ~ "\n" ~
    ( 1 * 2 * 3 ) ~ "\n" ~
    ( 1 / 2 / 3 ) ~ "\n\n" ~
    ( "string" ~ 'string' ~ `string` ) ~ "\n\n---\n\n"
)