-module(client).
-export([start/6, open/8]).

-define(client_node, 'alice@127.0.0.1').

start(ClientID, Entries, Reads, Writes, Conf, Server) ->
    spawn(?client_node, client, open,
			[ClientID, Entries, Reads, Writes, Conf, Server, 0, 0]).

open(ClientID, Entries, Reads, Writes, Conf, Server, Total, Ok) ->
    io:format("Client runs on node ~s~n", [node()]),
		Server ! {open, self()},
    receive
        {stop, From} ->
            %io:format("~w: Transactions TOTAL:~w, OK:~w, -> ~w % ~n",
            %[ClientID, Total, Ok, 100*Ok/Total]),
            io:format("~w, ~w, ~w, ~w, ~w, ~w, ~w~n",
            Conf ++ [ClientID, Ok/(Total+1)]),
            From ! {done, self()},
            ok;
        {transaction, Validator, Store} ->
            Handler = handler:start(self(), Validator, Store),
            case do_transaction(ClientID, Entries, Reads, Writes, Handler) of
                ok ->
                    open(ClientID, Entries, Reads, Writes, Conf, Server, Total+1, Ok+1);
                abort ->
                    open(ClientID, Entries, Reads, Writes, Conf, Server, Total+1, Ok)
            end
    end.

do_transaction(_, _, 0, 0, Handler) ->
    do_commit(Handler);
do_transaction(ClientID, Entries, 0, Writes, Handler) ->
    do_write(Entries, Handler, ClientID),
    do_transaction(ClientID, Entries, 0, Writes-1, Handler);
do_transaction(ClientID, Entries, Reads, 0, Handler) ->
    do_read(Entries, Handler),
    do_transaction(ClientID, Entries, Reads-1, 0, Handler);
do_transaction(ClientID, Entries, Reads, Writes, Handler) ->
    Op = rand:uniform(),
    if Op >= 0.5 ->
         do_read(Entries, Handler),
         do_transaction(ClientID, Entries, Reads-1, Writes, Handler);
       true -> 
         do_write(Entries, Handler, ClientID),
         do_transaction(ClientID, Entries, Reads, Writes-1, Handler)
    end.

do_read(Entries, Handler) ->
    Ref = make_ref(),
    Num = rand:uniform(Entries),
    Handler ! {read, Ref, Num},
    receive
        {value, Ref, Value} -> Value
    end.

do_write(Entries, Handler, Value) ->
    Num = rand:uniform(Entries),
    Handler ! {write, Num, Value}.

do_commit(Handler) ->
    Ref = make_ref(),
    Handler ! {commit, Ref},
    receive
        {Ref, Value} -> Value
    end.


    
