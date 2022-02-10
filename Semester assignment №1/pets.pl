cat(butsie).
cat(cornie).
cat(mac).

dog(flash).
dog(rover).
dog(spot).

color(butsie, brown).
color(cornie, black).
color(mac, red).
color(flash, spotted).
color(rover, red).
color(spot, white).

owns(tom, Pet) :- color(Pet, brown); color(Pet, black).
owns(kate, Pet) :- dog(Pet), not(color(Pet, white)), not(owns(tom, Pet)).
owns(alan, mac) :- not(owns(kate, butsie)), not(pedigree(spot)).

pedigree(Pet) :- owns(tom, Pet); owns(kate, Pet).

homeless(Pet) :- (cat(Pet); dog(Pet)), not(owns(tom, Pet)), not(owns(kate, Pet)), not(owns(alan, Pet)).

main([]) :- findall(Pet1, owns(kate, Pet1), Pets1), findall(Pet2, owns(tom, Pet2), Pets2), format('Kate owns: ~w\n', [Pets1]), format('Tom owns: ~w\n', [Pets2]).
main([Owner|_]) :- findall(Pet, owns(Owner, Pet), Pets), format('~w owns: ', [Owner]), writeln(Pets).

:- initialization(main, main).
