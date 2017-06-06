-module(opty).
-export([start/5, stop/1]).

%% Clients: Number of concurrent clients in the system
%% Entries: Number of entries in the store
%% Reads: Number of read operations per transaction
%% Writes: Number of write operations per transaction
%% Time: Duration of the experiment (in secs)

start(Clients, Entries, Reads, Writes, Time) ->
    register(s, server:start(Entries)),
		Loc = 'server@127.0.0.1',
		Conf = [Clients, Entries, Reads, Writes, Time],
    L = startClients(Clients, [], Entries, Reads, Writes, Conf, Loc),
    %io:format("Starting: ~w CLIENTS, ~w ENTRIES, ~w RDxTR, ~w WRxTR, DURATION ~w s~n", 
    %     [Clients, Entries, Reads, Writes, Time]),
    timer:sleep(Time*1000),
    stop(L).

stop(L) ->
    %io:format("Stopping...~n"),
    stopClients(L),
    waitClients(L),
    s ! stop.
    %io:format("Stopped~n")


startClients(0, L, _, _, _, _) -> L;
startClients(Clients, L, Entries, Reads, Writes, Conf, Loc) ->
    Pid = client:start(Clients, Entries, Reads, Writes, Conf, {s, Loc}),
    startClients(Clients-1, [Pid|L], Entries, Reads, Writes, Conf).

stopClients([]) ->
    ok;
stopClients([Pid|L]) ->
    Pid ! {stop, self()},	
    stopClients(L).

waitClients([]) ->
    ok;
waitClients(L) ->
    receive
        {done, Pid} ->
            waitClients(lists:delete(Pid, L))
    end.
