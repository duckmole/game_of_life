-module (life).
-export ([next/2]).
-export ([are_neighbors/2]).
-export ([neighbors/2]).
-export ([list_alive/1]).
-export ([turn/2]).
-export ([turn/1]).
-export ([state/1]).
-export ([init/2]).
-export ([run/0]).
-export ([run/2]).
-export ([display/1]).
-export ([display/2]).

next (dead, 3) ->
    alive;
next (dead, _)->
    dead;
next (_,N) when (N==2) or (N==3)->
    alive;
next(_,_) ->
    dead.

are_neighbors (Position, Position) ->
    false;
are_neighbors ({X1, Y1}, {X2, Y2}) ->
    (abs (X1 -X2) < 2) and (abs (Y1 -Y2) <2).

neighbors (Position, Field) ->
    Filter = fun (Other) ->
		     are_neighbors (Position, Other)
	     end,
    lists: filter (Filter, Field).

list_alive (Field) ->
    [Postion || {Postion, alive} <- Field].

turn ({Position, State}, Field) ->
    List_alive = list_alive(Field),
    Nb_alive = length (neighbors (Position, List_alive)),
    {Position, next (State, Nb_alive)}.

turn (Field) ->
    [turn (Cell, Field) || Cell <- Field].

state (Field) ->
    case ([] == [Cell || Cell = {_, alive} <- Field]) of
	true -> dead;
	_    -> alive
    end.    

init ({X_max, Y_max}, Nb_alives) ->
    Cells = [{{X, Y}, dead} || X <- lists: seq (1, X_max),
			       Y <- lists: seq (1, Y_max)],
    lists: sort(add_alive (Cells, Nb_alives)).

add_alive (Cells) ->
    {A1,A2,A3} = now(),
    random: seed (A1, A2, A3),
    Deads = [Cell || {_, dead} = Cell <- Cells],
    Nb_deads = length (Deads),
    case Nb_deads of
	0 -> error;
	_ -> 
	    Change = random: uniform (Nb_deads),
	    {Position,dead} = lists: nth (Change, Deads),
	    [{Position, alive} | lists: delete ({Position, dead}, Cells)]
    end.

add_alive (Cells, 0) ->
    Cells;
add_alive (Cells, N) ->
    add_alive (add_alive (Cells), N-1).

run (Field, Display) ->
    run (Field, 0, Display).

run (Field, Round, Display) ->
    display (Field, Display),
    case state (Field) of
	dead ->
	    {dead, Round};
	alive ->
	    New_Field = turn (Field),
	    run (New_Field, Round+1, Display)
    end.
 
display (alive) ->
    "X";
display (dead) ->
    " ";
display ({{_,1}, State}) ->
    "~n" ++ display (State);
display ({{_,_}, State}) ->
    display (State);
display (Field) ->
    List = [display (Cell) || Cell <- Field],
    lists: flatten (List).

display (_, no_display) ->
    ok;
display (Field, _) ->
    timer: sleep (100),
    io:fwrite (display(Field)).

run () ->
    X_max = 40,
    Y_max = 100,
    Nb_alives = 400,
    Dimension = {X_max, Y_max},
    life: run (life: init (Dimension, Nb_alives), display).
