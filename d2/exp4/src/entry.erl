-module(entry).
-export([new/1]).

new(Value) ->
    spawn_link(fun() -> init(Value) end).

init(Value) ->
    entry(Value, 0, 0, []).

entry(Value, WriteT, ReadT, Pending) ->
    receive
        {read, Ref, Time, From} ->
            if
              (Time > WriteT) ->
                  case suspend_read(Time, Ref, From, Pending) of
                      no ->
                          From ! {replyrd, {ok, Value}, Ref},
                          entry(Value, WriteT, Time, Pending);
                      NewPending ->
                          entry(Value, WriteT, ReadT, NewPending)
                  end;
              true ->
                  From ! {reply, abort, Ref},
                  entry(Value, WriteT, ReadT, Pending)
            end;
        {write, Ref, Time, NewValue, From} ->
            if
              (Time >= ReadT) and (Time > WriteT) ->
                  NewPending = suspend_write(Time, Ref, NewValue, Pending),
                  From ! {replywr, ok, Ref},
                  entry(Value, WriteT, ReadT, NewPending);
              true ->
                  From ! {reply, abort, Ref},
                  entry(Value, WriteT, ReadT, Pending)
            end;
        {commit, Time} ->
            case Pending of
                [{Time, {write, _, NewValue}}|RestPending] ->
                    commit_write(NewValue, Time, ReadT, RestPending);
                _ ->
                    NewPending = suspend_commit_write(Time, Pending),
                    entry(Value, WriteT, ReadT, NewPending)
            end;
        {abort, Time} ->
            NewPending = abort_write(Time, Pending),
            commit_write(Value, WriteT, ReadT, NewPending);
        stop ->
            ok
    end.

suspend_read(Time, Ref, From, Pending) ->
    case find_read(Time, Pending) of
        {equal, Value} ->
            From ! {replyrd, {ok, Value}, Ref},
            Pending;
        less ->
            lists:keysort(1, [{Time, {read, Ref, From}}|Pending]);
        no ->
            no
    end.

find_read(_, []) ->
    no;
find_read(Time, Pending) ->
    [Item|Rest] = Pending,
    case Item of
        {Time, {write, _, Value}} ->
            {equal, Value};
        {T, {write, _, _}} when T < Time ->
            less;
        _ ->
            find_read(Time, Rest)
    end.

suspend_write(Time, Ref, NewValue, Pending) ->
    case lists:keyfind(Time, 1, Pending) of
        {Time, {write, _, _}} ->
            lists:keyreplace(Time, 1, Pending, {Time, {write, Ref, NewValue}});
        false ->
            lists:keysort(1, [{Time, {write, Ref, NewValue}}|Pending])
    end.

commit_write(Value, WriteT, ReadT, Pending) ->
    case Pending of
        [] ->
            entry(Value, WriteT, ReadT, []);
        [{NewReadT, {read, Ref, From}}|RestPending] ->
            From ! {replyrd, {ok, Value}, Ref},
            commit_write(Value, WriteT, NewReadT, RestPending);
        [{NewWriteT, {writecommitted, NewValue}}|RestPending] ->
            commit_write(NewValue, NewWriteT, ReadT, RestPending);
        _ ->
            entry(Value, WriteT, ReadT, Pending)
    end.

suspend_commit_write(Time, Pending) ->
    case lists:keyfind(Time, 1, Pending) of
        {Time, {write, _, NewValue}} ->
            lists:keyreplace(Time, 1, Pending, {Time, {writecommitted, NewValue}});
	false ->
	    Pending
    end.

abort_write(Time, Pending) ->
    lists:keydelete(Time, 1, Pending).
