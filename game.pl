:- dynamic now_here/1, here/2, holding/1, eat_food/1.

:- retractall(here(_, _)),
	retractall(now_here(_)),
	retractall(holding(_)),
	retractall(eat_food(_)).

start :- instructions , look.


instructions  :-
	nl,
		write('you are in the house somewhere'), nl,
        write('you can walk in different directions on it'), nl,
        write('Available commands:'), nl,
        write('instructions.			-- start the game.'), nl,
        write('move(Dir).				-- to go - direction.'), nl,
        write('n,s,e,w	                -- direction'),nl,
        write('pickup(object).          -- pick up  object.'), nl,
        write('drop(object).            -- drop down object.'), nl,
        write('eat(object).             -- eat an object.'), nl,
        write('look.                    -- look around you.'), nl,
        nl,
	look.


path(hall, e, living_room).
path(living_room, n, hall).
path(living_room, s, diningroom).
path(hall, s, living_room).
path(bathroom, w, diningroom).
path(diningroom, s, bedroom).
path(diningroom, e, bathroom).
path(diningroom, w, kitchen).
path(bedroom, n, diningroom).
path(bedroom, e, livingroom).
path(bedroom, w, finalroom).
%path(living_room, w, bedroom).
path(finalroom, e, bedroom).
path(kitchen, e, diningroom).
path(kitchen, n, basement).

here(living_room, smartphone).
here(diningroom, icecream).
here(kitchen, meat).
here(livingroom, money).
here(finalroom, prize).
here(hall, taburetka).

food(icecream).
food(meat).

count_n(X) :- X is X.

now_here(hall).	% start location

move(Dir) :-
	now_here(kitchen),
	path(kitchen, Dir, basement),
	retract(now_here(kitchen)),
	assert(now_here(basement)),
	write('You have moved to '), write(basement), write('.'), nl,
	look,
	lose,
	!.

move(Dir) :- 
	now_here(kitchen),
	path(kitchen, Dir, basement),
	write('Can not move to'), write(basement), write(','), nl,
	look,
	!.

move(Dir) :- %conditional movement
	now_here(bedroom),
	path(bedroom, Dir, finalroom),
	holding(icecream),
	retract(now_here(bedroom)),
	assert(now_here(finalroom)),
	write('You have moved to '), write(finalroom), write('.'), nl,
	look,
	win,
	!.

move(Dir) :- %conditional movement
	now_here(bedroom),
	path(bedroom, Dir, finalroom),
	write('Can not move to'), write(finalroom), write(','), nl,
	write('find icecream'), nl,
	look,!.

move(Dir) :-
	now_here(X),
	path(X, Dir, Y),
	retract(now_here(X)),
	assert(now_here(Y)),
	write('You have moved to '), write(Y), write('.'), nl,
	look,!.

move(_) :-
	write('You can not move that direction.'), nl.


pickup(X) :-
	holding(X),
	write('You are already holding it'), nl,
	!.

pickup(X) :-
	now_here(Place),
	here(Place, X),
	retract(here(Place, X)),
	assert(holding(X)),
	write('You have picked it up.'), nl,
	look,!.

pickup(_) :-
	write('I do not see that here.'), nl.

drop(X) :-
        holding(X),
        now_here(Place),
        retract(holding(X)),
        assert(here(Place, X)),
        write('OK.'),
        nl,look,!.

drop(_) :-
        write('You thew it away'),
        nl.
%
% 
% 
%

eat(X) :-
	food(meat),
	holding(meat),
	assert(eat_food(meat)),
	retract(holding(meat)),
	write('It taste good.'), nl,
	write('but no more left'), nl,!.

eat(X) :-
	food(X),
	holding(X),
	assert(eat_food(X)),
	write('It taste good.'), nl,!.

eat(_) :-
	write('Did you pick up somethings?'), nl.

look :-
	now_here(X),
	describe(X),
	list_objects_at(X).

list_objects_at(X) :-
	here(X, Obj),
	write('There is a '), write(Obj), write(' on the ground.'), nl,
	fail.

list_objects_at(_).

lose :-
        nl,
        write('you lose.'),
        nl.
win :-
        nl,
        write('you win.'),
        nl.

describe(X) :-
	write('You are in '), write(X), nl,
	able_path(X),nl.


able_path(X) :-
        path(X, D, Y),
	write('enter '),write(D),write(', You can go to '), write(Y), nl, fail.

able_path(_).