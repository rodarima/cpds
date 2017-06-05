-module(client).
-export([start/6]).

sample(Entries, N) ->
	S = lists:seq(1, Entries),
	Mix = [X||{_,X} <- lists:sort(
		[{rand:uniform(), L} || L <- S]
	)],
	lists:sublist(Mix, N).

start(ClientID, Entries, Reads, Writes, Conf, Server) ->
    spawn(fun() -> open(ClientID, Entries, Reads, Writes, Conf, Server, 0, 0) end).

open(ClientID, Entries, Reads, Writes, Conf, Server, Total, Ok) ->
    Server ! {open, self()},
    receive
        {stop, From} ->
            %io:format("~w: Transactions TOTAL:~w, OK:~w, -> ~w % ~n",
            %[ClientID, Total, Ok, 100*Ok/Total]),
            io:format("~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w~n",
            Conf ++ [ClientID, Ok/Total]),
            From ! {done, self()},
            ok;
        {transaction, Validator, Store} ->
            Handler = handler:start(self(), Validator, Store),
						Access = lists:nth(6, Conf),
						Sublist = sample(Entries, Access),
            case do_transaction(ClientID, Access, Reads, Writes, Handler, Sublist) of
                ok ->
                    open(ClientID, Entries, Reads, Writes, Conf, Server, Total+1, Ok+1);
                abort ->
                    open(ClientID, Entries, Reads, Writes, Conf, Server, Total+1, Ok)
            end
    end.

do_transaction(_, _, 0, 0, Handler, _) ->
    do_commit(Handler);
do_transaction(ClientID, Entries, 0, Writes, Handler, Sublist) ->
    do_write(Entries, Handler, ClientID, Sublist),
    do_transaction(ClientID, Entries, 0, Writes-1, Handler, Sublist);
do_transaction(ClientID, Entries, Reads, 0, Handler, Sublist) ->
    do_read(Entries, Handler, Sublist),
    do_transaction(ClientID, Entries, Reads-1, 0, Handler, Sublist);
do_transaction(ClientID, Entries, Reads, Writes, Handler, Sublist) ->
    Op = rand:uniform(),
    if Op >= 0.5 ->
         do_read(Entries, Handler, Sublist),
         do_transaction(ClientID, Entries, Reads-1, Writes, Handler, Sublist);
       true -> 
         do_write(Entries, Handler, ClientID, Sublist),
         do_transaction(ClientID, Entries, Reads, Writes-1, Handler, Sublist)
    end.

do_read(Entries, Handler, Sublist) ->
    Ref = make_ref(),
    Index = rand:uniform(Entries),
		Num = lists:nth(Index, Sublist),
    Handler ! {read, Ref, Num},
    receive
        {value, Ref, Value} -> Value
    end.

do_write(Entries, Handler, Value, Sublist) ->
    Index = rand:uniform(Entries),
    Num = lists:nth(Index, Sublist),
    Handler ! {write, Num, Value}.

do_commit(Handler) ->
    Ref = make_ref(),
    Handler ! {commit, Ref},
    receive
        {Ref, Value} -> Value
    end.


    
