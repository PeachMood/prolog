%To start the program, it is enough to write in the terminal "swipl 20214-VoronovaAS-A3.pl"
%Further instructions will be provided by the expert system itself

rule("Python", [2, 6, 7, 8, 9]).
rule("JavaScript", [1, 2, 8, 10]).
rule("LISP", [1, 3, 4, 10]).
rule("Java", [2, 3, 7, 8]).
rule("Ruby", [3, 7, 8, 9]).
rule("PHP", [6, 7, 8, 9]).
rule("C++", [1, 2, 8]).
rule("C", [1, 4, 5]).
rule("Go", [2, 3, 6]).
rule("C#", [2, 7, 8]).
rule("Rust", [1, 3]).
rule("Assembler", [1, 4]).
rule("Haskell", [1, 11]).
rule("Swift", [2, 8]).
rule("Perl", [3, 6]).
rule("SQL", [3, 7]).
rule("Pascal", [4, 5]).
rule("Fortran", [4]).
rule("Kumir", [5]).
rule("Prolog", [10]).

property(1, "suffer"). %difficult programming languages
property(2, "be in trend"). %popular programming languages
property(3, "make a million dollars per nanosecond"). %highly paid programming languages
property(4, "appeal to the spirits of our ancestors"). %old programming languages
property(5, "teach programming at school"). %programming languages most often taught in schools
property(6, "see an animal on the logo of the programming language").
property(7, "start every morning with the 500 Internal Server Error"). %programming languages for backend
property(8, "know what the word encapsulation means"). %object-oriented programming languages
property(9, "read all three volumes of War and Peace while your program finishes execution"). %slow programming languages
property(10, "help artificial intelligence to enslave humanity"). %logical programming languages
property(11, "play a survival game called Monads"). 


%Predicates for working with the knowledge base
user_no(Property) :- database_no(Property), !.
user_yes(Property) :- database_yes(Property), !.
user_yes(Property) :- not(user_no(Property)), !, get_answer(Property).

save_answer("yes", Property) :- asserta(database_yes(Property)), nl.
save_answer("no", Property) :- asserta(database_no(Property)), nl, fail.
save_answer(Answer, Property) :- Answer \== "yes", Answer \== "no", !, 
                                 writeln("I really wanted to understand what you answered, but I couldn't"),
                                 writeln("Could you answer the question again?"), nl, 
                                 get_answer(Property).


%Helper predicates
check_properties([]).
check_properties([Property | Other]) :- user_yes(Property), check_properties(Other).

print_properties([Property]) :- property(Property, Text), format("to ~w.\n", [Text]).
print_properties([Property1, Property2]) :- property(Property1, Text1), property(Property2, Text2), format("to ~w and to ~w.\n", [Text1, Text2]).
print_properties([Property | Other]) :- property(Property, Text), format("to ~w, ", Text), print_properties(Other).

imitate_processing :- writeln("Wait, I'm processing your response..."), sleep(2), writeln("Wait a little more..."), sleep(2).


%Predicates for object search
get_answer(Property) :- \+ property(Property, _), !, writeln("I cannot formulate a question ...").
get_answer(Property) :- property(Property, []), !, writeln("I cannot formulate a question ...").
get_answer(Property) :- property(Property, Text), format("Do you want to ~w? (yes/no)\n", [Text]),
                        write("|: "), read_string(current_input, "\n", "", _, Answer), 
                        save_answer(Answer, Property).

detailed_report("no").
detailed_report("yes") :- nl, writeln("You answered \"yes\" on the following questions: "), 
                          database_yes(Property), property(Property, Text), format("Do you want to ~w?\n", [Text]), fail ; !.
detailed_report(_) :- writeln("Oh, I couldn't understand what you said. Can you repeat?"), nl,
                      writeln("Do you want to get detailed report? (yes/no)"), 
                      write("|: "), read_string(current_input, "\n", "", _, Answer), detailed_report(Answer).

mode_advise :- rule(Language, Properties), check_properties(Properties) 
               -> imitate_processing, format("Ready! Based on your answers, I think the programming language ~w is the best for you!\n", [Language]), nl,
                  writeln("Remind you what questions you answered \"yes\"? (yes/no)"),
                  write("|: "), read_string(current_input, "\n", "", _, Answer),
                  detailed_report(Answer), nl, 
                  writeln("Do you still need my help? (go/stop)");
               imitate_processing, writeln("Sorry friend, I couldn't find anything for you."), nl,
               writeln("Can we try again? (go/stop)").


%Predicates for providing information about an object
mode_tell(Language) :- \+ rule(Language, _), !, format("Oops, I can't say anything about programming language ~w.\n", [Language]), nl,
                       writeln("Can we try again? (go/stop)").
mode_tell(Language) :- rule(Language, []), !, format("Oops, I can't say anything about programming language ~w.\n", [Language]), nl, 
                       writeln("Can we try again? (go/stop)").
mode_tell(Language) :- rule(Language, Properties), format("Ready! I think, ~w is a perfect programming language for those who want ", [Language]), 
                       print_properties(Properties), nl,
                       writeln("Do you still need my help? (go/stop)").


%Predicate for determining the operating mode of the expert system
mode("tell") :- writeln("Great! So tell me the name of the programming language you want information about."),
                write("|: "), read_string(current_input, "\n", "", _, Answer), nl,
                imitate_processing, mode_tell(Answer).

mode("advise") :- retractall(database_yes(_)), retractall(database_no(_)),
                  writeln("Cool! Now you need to answer a few questions."), mode_advise.

mode(_) :- writeln("Oh, I couldn't understand what you said. Can you repeat?"),
           writeln("Which mode? \"advise\" or \"tell\"?"),
           write("|: "), read_string(current_input, "\n", "", _, Answer), nl, mode(Answer).


%Predicate for starting and stopping the expert system
run_program("stop") :- write("So you're going? It's a pity. I'll miss you. Come back soon, my friend!").
run_program("go") :- writeln("Okay, let's go!"),
                     writeln("First tell me, do you want me to advise you something or do you want to learn something about some programming language? (advise/tell)"),
                     write("|: "), read_string(current_input, "\n", "", _, Answer1), nl, mode(Answer1),
                     write("|: "), read_string(current_input, "\n", "", _, Answer2), nl, run_program(Answer2).
run_program(_) :- writeln("I really wanted to understand what you answered, but I couldn't."), 
                  writeln("Can you tell me again what you want? (go/stop)"),
                  write("|: "), read_string(current_input, "\n", "", _, Answer), nl, run_program(Answer).


%Greeting from the expert system and transition to the main algorithm
main :- writeln("Hello, my friend! I'm a digital assistant Proger."),
        writeln("If you can't decide which programming language you should start learning, I will be happy to help you in this matter!"),
        writeln("Also, I can tell you what I know about some programming languages."),
        writeln("Just answer \"go\" and we'll get started. If you are not ready to start now, write \"stop\"."),
        write("|: "), read_string(current_input, "\n", "", _, Answer), nl, run_program(Answer).

:- initialization(main, main).
