-module(store).
-export([new/1, stop/1, lookup/2]).

new(N) ->
    list_to_tuple(entries(N, [])).

stop(Store) ->
    lists:foreach(fun(E) -> 
                    E ! stop 
                  end, 
                  tuple_to_list(Store)).

lookup(I, Store) ->
    element(I, Store). % this is a builtin function

entries(0, ListSoFar) ->
    ListSoFar;
entries(N, ListSoFar) ->
    Entry = entry:new(0),
    entries(N-1, [Entry|ListSoFar]).
