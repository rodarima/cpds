-module(server).
-export([start/1]).

start(N) ->
    spawn(fun() -> init(N) end).

init(N) ->
    Store = store:new(N),
    server(1, Store).
    
server(Time, Store) ->
    receive 
        {open, Client} ->
            Client ! {transaction, Time, Store},
            server(Time+1, Store);
        stop ->
            store:stop(Store)
    end.
