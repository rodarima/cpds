-module(client).
-export([start/6]).

start(ClientID, Entries, Reads, Writes, Conf, Server) ->
    spawn(fun() -> open(ClientID, Entries, Reads, Writes, Conf, Server, 0, 0) end).

open(ClientID, Entries, Reads, Writes, Conf, Server, Total, Ok) ->
    Server ! {open, self()},
    receive
        {stop, From} ->
            %io:format("~w: Transactions TOTAL:~w, OK:~w, -> ~w % ~n",
            %[ClientID, Total, Ok, 100*Ok/Total]),
            io:format("~w, ~w, ~w, ~w, ~w, ~w, ~w~n",
            Conf ++ [ClientID, Ok/Total]),
            From ! {done, self()},
            ok;
        {transaction, Time, Store} ->
            Tref = make_ref(),
            Handler = handler:start(self(), Tref, Time, Store),
            case do_transaction(ClientID, Entries, Reads, Writes, Handler, Tref) of
                ok ->
                    open(ClientID, Entries, Reads, Writes, Conf, Server, Total+1, Ok+1);
                abort ->
                    open(ClientID, Entries, Reads, Writes, Conf, Server, Total+1, Ok)
            end
    end.

do_transaction(_, _, 0, 0, Handler, Tref) ->
    do_commit(Handler, Tref);
do_transaction(ClientID, Entries, 0, Writes, Handler, Tref) ->
    case do_write(Entries, Handler, ClientID, Tref) of
        abort ->
            abort;
        ok ->
            do_transaction(ClientID, Entries, 0, Writes-1, Handler, Tref)
    end;
do_transaction(ClientID, Entries, Reads, 0, Handler, Tref) ->
    case do_read(Entries, Handler, Tref) of
        abort ->
            abort;
        _ ->
            do_transaction(ClientID, Entries, Reads-1, 0, Handler, Tref)
    end;
do_transaction(ClientID, Entries, Reads, Writes, Handler, Tref) ->
    Op = rand:uniform(),
    if Op >= 0.5 ->
         case do_read(Entries, Handler, Tref) of
             abort ->
                 abort;
             _ ->
                 do_transaction(ClientID, Entries, Reads-1, Writes, Handler, Tref)
         end;
       true -> 
         case do_write(Entries, Handler, ClientID, Tref) of
             abort ->
                 abort;
             ok ->
                 do_transaction(ClientID, Entries, Reads, Writes-1, Handler, Tref)
         end
    end.

do_read(Entries, Handler, Tref) ->
    Ref = make_ref(),
    Num = rand:uniform(Entries),
    Handler ! {read, Ref, Num},
    receive
        {value, Ref, {ok, Value}} -> 
            Value;
        {abort, Tref} ->
            abort
    end.

do_write(Entries, Handler, Value, Tref) ->
    Ref = make_ref(), 
    Num = rand:uniform(Entries),
    Handler ! {write, Ref, Num, Value},
    receive
        {value, Ref, ok} ->
            ok;
        {abort, Tref} ->
            abort
    end.

do_commit(Handler, Tref) ->
    Handler ! commit,
    receive
        {commit, Tref} ->
            ok;
        {abort, Tref} ->
            abort
    end.

