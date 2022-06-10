position(center,'You are in center of the room.').
position(bed,'You are next to the bed.').
position(wardrobe,'You are next to the wardrobe.').
position(parapet,'You are next to windowsill,').
position(tv, 'You are next to the TV').
position(desk,'You are next to the desk.').
position(table,'You are next to the table.').

:-dynamic dostrzegasz/2.
detect(table, [remote, cans]).
detect(wardrobe, [stainedTShirt, shirt]).
detect(bed, [pizza]).
detect(windowsill, [book]).
detect(desk, [notebook]).
detect(center, []).
detect(tv, []).
detect(X) :- 
    detect(X, Y),
    write('You have seen: '), write(Y).

search(I) :-
    detect(X, Y),
    member(I, Y),
    write(I), write(' is placed near '), write(X), write('.'),
    !.

:-dynamic actualPosition/1.
actualPosition(center).

:-dynamic eq/1.
eq([]).
eq :-
    eq(X),
    write(X).

positions :- 
    Positions = [center, bed, wardrobe, windowsill, tv, desk, table],
    write(Positions).

goto(X) :- 
    retractall(actualPosition(_)), 
    assert(actualPosition(X)), 
    position(X, Y), 
    write(Y), 
    nl.

lookAround :- 
    actualPosition(X),
    position(X, Y),
    writeln(Y),
    detect(X),
    nl.
    
switch(X, [Val:Goal|Cases]) :-
    ( X=Val ->
        call(Goal)
    ;
        switch(X, Cases)
    ).

start :- 
    writeln('Available moves are [goto, lookAround, pick, eq, search]'),
    read(X),
    switch(X, [
    	'goto': (
               write('Where would you like to go? '), positions, nl,
               read(Y),
               call(goto(Y))
        ),
        'lookAround': call(lookAround),
        'pick': (
               actualPosition(P),
               write('What would you like to pick up? '), detect(P), nl,
               detect(P, Li),
               length(Li, L),
               L > 0 -> ( 
                        read(I),
                        select(I, Li, Li2),
                        retractall(detect(P, _)),
                        assert(detect(P, Li2)),
                    	eq(Le),
                        append(Le, [I], Nle),
                        retractall(eq(_)),
                        assert(eq(Nle)),
                        write('You have picked up '), write(I), write('.'), nl
               ); writeln('You have nothing to pick up.')
        ),
        'eq': (
              write('Equipment: '),
              eq, 
              nl
        ),
        'search': (
              writeln('What are you looking for? '), read(I), search(I), nl
        )
    ]), 
    start;
    writeln('Error ;(').