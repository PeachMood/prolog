item("Wish You Were Here", "Pink Floyd", 1975, "Progressive rock").
item("The Dark Side of the Moon", "Pink Floyd", 1973, "Progressive rock").
item("The Wall", "Pink Floyd", 1979, "Progressive rock").

item("Thriller", "Michael Jackson", 1982, "Pop").
item("Bad", "Michael Jackson", 1987, "Pop").
item("Dangerous", "Michael Jackson", 1991, "R&B").

item("1", "The Beatles", 2000, "Rock").
item("Abbey Road", "The Beatles", 1969, "Rock").
item("Yellow Submarine", "The Beatles", 1969, "Psychedelia").
item("Let It Be", "The Beatles", 1970, "Rock").

item("The Bodyguard", "Whitney Houston", 1992, "R&B").
item("My Love Is Your Love", "Whitney Houston", 1998, "R&B").
item("Just Whitney", "Whitney Houston", 2002, "R&B").

item("Youth", "BTS", 2016, "Pop").
item("Wings", "BTS", 2016, "Hip hop").
item("Love Yourself: Tear", "BTS", 2018, "R&B").
item("Map of the Soul: 7", "BTS", 2020, "Hip hop").
item("Be", "BTS", 2020, "Pop").

item("Come On Over", "Shania Twain", 1997, "Country").
item("Back in Black", "AC/DC", 1980, "Hard Rock").
item("Bat Out of Hell", "Meat Loaf", 1977, "Hard Rock").
item("Saturday Night Fever", "Bee Gees", 1977, "Disco").
item("Rumours", "Fleetwood Mac", 1977, "Soft Rock").
item("Hotel California", "Eagles", 1976, "Soft Rock").
item("Led Zeppelin IV", "Led Zeppelin", 1971, "Hard Rock").
item("Jagged Little Pill", "Alanis Morissette", 1995, "Alternative rock").

is_number([]).
is_number([Char | Chars]) :- char_type(Char, digit) -> is_number(Chars).

print_albums1(AlbumTitle, PerformerName, ReleaseYear, AlbumGenre) :-  \+ item(AlbumTitle, PerformerName, ReleaseYear, AlbumGenre), !, writeln("Nothing found!").
print_albums1(AlbumTitle, PerformerName, ReleaseYear, AlbumGenre) :-
    writeln("We have the following albums:"), 
    item(AlbumTitle, PerformerName, ReleaseYear, AlbumGenre),
    writeln("====================================="),
    write("Album: "), writeln(AlbumTitle),
    write("Performer: "), writeln(PerformerName),
    write("Album release year: "), writeln(ReleaseYear),
    write("Genre: "), writeln(AlbumGenre),
    writeln("====================================="), 
    fail; ! .

print_albums2(LowerBound, UpperBound) :- \+ (item(_, _, ReleaseYear, _), between(LowerBound, UpperBound, ReleaseYear)), !, writeln("Nothing found!").
print_albums2(LowerBound, UpperBound) :-
    writeln("We have the following albums:"),
    item(AlbumTitle, PerformerName, ReleaseYear, AlbumGenre),
    between(LowerBound, UpperBound, ReleaseYear), 
    writeln("====================================="),
    write("Album: "), writeln(AlbumTitle),
    write("Performer: "), writeln(PerformerName),
    write("Album release year: "), writeln(ReleaseYear),
    write("Genre: "), writeln(AlbumGenre),
    writeln("====================================="),
    fail;!. 

find_release("", UpperBound) :- find_release("1969", UpperBound).
find_release(LowerBound, "") :- find_release(LowerBound, "2020").
find_release(LowerBound, UpperBound) :-
    string_chars(LowerBound, Lower),
    string_chars(UpperBound, Upper),
    is_number(Lower), is_number(Upper)
        -> number_string(LowerNumber, LowerBound),
           number_string(UpperNumber, UpperBound),
           print_albums2(LowerNumber, UpperNumber);
    writeln("Lower and upper bounds should be numbers. Try to enter bounds again."), nl, process_request("3").

process_request("1") :- 
    writeln("You have chosen to search by album title."), 
    write("Please enter the title: "), 
    read_string(current_input, "\n", "", _, AlbumTitle), nl,
    print_albums1(AlbumTitle, _, _, _), nl.

process_request("2") :- 
    writeln("You have chosen to search by performer name."),    
    write("Please enter the name: "), 
    read_string(current_input, "\n", "", _, PerformerName), nl,
    print_albums1(_, PerformerName, _, _), nl.

process_request("3") :- 
    writeln("You have chosen to search by album release year."), 
    write("Please enter the lower bound: "), 
    read_string(current_input, "\n", "", _, LowerBound),
    write("Please enter the upper bound: "),
    read_string(current_input, "\n", "", _, UpperBound), nl,
    find_release(LowerBound, UpperBound), nl.

process_request("4") :- 
    writeln("You have chosen to search by album genre."), 
    write("Please enter the genre: "), 
    read_string(current_input, "\n", "", _, AlbumGenre), nl,
    print_albums1(_, _, _, AlbumGenre), nl.

process_request(_) :- writeln("Incorrect search parameter. Try to enter your request again"), get_user_request.

get_user_request :- 
    writeln("Please select search parameter:"),
    writeln("1 - Album title"),
    writeln("2 - Performer"), 
    writeln("3 - Album release year"),
    writeln("4 - Genre"), 
    write("|: "), 
    read_string(current_input, "\n\r", "\n\r", _, Request), nl, 
    process_request(Request),
    run.

program("yes") :- get_user_request.
program("no") :- writeln("Goodbye! Hope to see you soon!").
program(_) :- writeln("Incorrect input. Please, try to enter your answer again"), run.

run :- 
    writeln("Do you want to search something (yes/no)?"),
    write("|: "), 
    read_string(current_input, "\n", "", _, Input), nl,
    program(Input).

main :- 
    writeln("Welcome to the catalog of music albums!"), nl, 
    run.

:- initialization(main, main).
