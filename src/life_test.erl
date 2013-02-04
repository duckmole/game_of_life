%Si une c vivante et < 2 voisines vivantes, mort à l'étape suivante ;
%Si une c vivante et > 3 voisines vivantes, mort à l'étape suivante ;
%Si une c vivante et 2 ou 3 voisines vivantes, vivante à l'étape suivante ;
%Si une c morte et 3 voisines vivantes, vivante à l'étape suivante.
-module (life_test).
-test (exports).
-export ([rule_1/0]).
-export ([rule_2/0]).
-export ([rule_3/0]).
-export ([rule_4/0]).
-export ([are_neighbors/0]).
-export ([neighbors/0]).
-export ([list_alive/0]).
-export ([turn_for_1_cell/0]).
-export ([turn/0]).
-export ([state/0]).
-export ([init/0]).
-export ([run/0]).
-export ([display_state/0]).
-export ([display_cell/0]).
-export ([display/0]).
-export ([no_display/0]).

check_alive (List) ->
    [dead = life: next (alive, N) || N <- List].

rule_1 () ->
    check_alive ([0,1]).
rule_2 () ->
    check_alive (lists: seq (4,8)).
rule_3 () ->
    [alive = life: next (alive, N) || N <- [2,3]].
rule_4 () ->
    alive = life: next (dead, 3),
    [dead = life: next (dead, N) || N <- [0,1,2]],
    [dead = life: next (dead, N) || N <- lists:seq (4,8)].
    
are_neighbors () ->
    true = life: are_neighbors ({1,1}, {1,2}),
    false = life: are_neighbors ({1,1}, {1,3}),
    false = life: are_neighbors ({1,1}, {1,1}).
    
neighbors () ->
    Field = [{1,1}, {1,2}, {1,3}],
    [{1,2}] = life: neighbors ({1,1}, Field),
    [{1,1}, {1,3}] = life: neighbors ({1,2}, Field).
    
list_alive () ->
    Field = [{{1,1}, alive}, {{1,2}, dead}, {{1,3}, alive}],
    [{1,1}, {1,3}] = life: list_alive (Field).

turn_for_1_cell () ->
    Cell = {{1,2}, alive},
    Field = [{{1,1}, alive}, {{1,2}, alive}, {{1,3}, alive}],
    Cell = life: turn  (Cell, Field),
    {{1,1}, dead} = life: turn ({{1,1}, alive}, Field).

turn () ->
    Init = [{{1,1}, alive}, {{1,2}, alive}, {{1,3}, alive}],
    Next = [{{1,1}, dead}, {{1,2}, alive}, {{1,3}, dead}],
    Next = life: turn (Init).

state () ->
    alive = life: state ([{{1,1}, alive}, {{1,2}, alive}, {{1,3}, alive}]),
    alive = life: state ([{{1,1}, dead}, {{1,2}, alive}, {{1,3}, dead}]),
    dead  = life: state ([{{1,1}, dead}, {{1,2}, dead}, {{1,3}, dead}]).

nb_alive (Cells) ->
    length ([Cell || {_, alive} = Cell <- Cells]).

init () ->
    Nb_alives = 10,
    Dimension = {10, 10},
    Cells = life: init (Dimension, Nb_alives),
    100 = length (Cells),
    Nb_alives = nb_alive (Cells).

run () ->
    Max = 5,
    Dimension = {Max, Max},
    {dead, 1} = life: run (life: init (Dimension, 1), no_display),
    {dead, 2} = life: run (life: init (Dimension, Max*Max), no_display).

display_state () ->
    "X" = life: display (alive),
    " " = life: display (dead).

display_cell () ->
    "~n " = life: display ({{1,1}, dead}),
    " " = life: display ({{1,2}, dead}).

display () ->
    Field = [{{1,1}, alive}, {{1,2}, dead}, {{2,1}, alive}],
    "~nX ~nX" = life: display (Field).

no_display () ->
    Field = [{{1,1}, alive}, {{1,2}, dead}, {{2,1}, alive}],
    ok = life: display (Field, no_display),
    ok = life: display (Field, display).
    

