-module(paxy).
-export([start/1, stop/0, stop/1]).

-define(RED, {255,0,0}).
-define(BLUE, {0,0,255}).
-define(GREEN, {0,255,0}).

% Sleep is a list with the initial sleep time for each proposer
start(Sleep) ->
    AcceptorNames = ["Acceptor a", "Acceptor b", "Acceptor c", 
    "Acceptor d", "Acceptor e"],
    AccRegister = [a, b, c, d, e],
    ProposerNames = [{"Proposer kurtz", ?RED}, {"Proposer kilgore", ?GREEN}, 
                     {"Proposer willard", ?BLUE}],
    PropInfo = [{kurtz, ?RED}, {kilgore, ?GREEN}, {willard, ?BLUE}],
    register(gui, spawn(fun() -> gui:start(AcceptorNames, ProposerNames) end)),
    gui ! {reqState, self()},
    receive
        {reqState, State} ->
            {AccIds, PropIds} = State,
            start_acceptors(AccIds, AccRegister),
            start_proposers(PropIds, PropInfo, AccRegister, Sleep)
    end,
    true.
    
start_acceptors(AccIds, AccReg) ->
    case AccIds of
        [] ->
            ok;
        [AccId|Rest] ->
            [RegName|RegNameRest] = AccReg,
            register(RegName, acceptor:start(RegName, AccId)),
            start_acceptors(Rest, RegNameRest)
    end.

start_proposers(PropIds, PropInfo, Acceptors, Sleep) ->
    case PropIds of
        [] ->
            ok;
        [PropId|Rest] ->
            [{RegName, Colour}|RestInfo] = PropInfo,
            [FirstSleep|RestSleep] = Sleep,
            proposer:start(RegName, Colour, Acceptors, FirstSleep, PropId),	
            start_proposers(Rest, RestInfo, Acceptors, RestSleep)
        end.

stop() ->
    stop(a),
    stop(b),
    stop(c),
    stop(d),
    stop(e),
    stop(gui).

stop(Name) ->
    case whereis(Name) of
        undefined ->
            ok;
        Pid ->
            Pid ! stop
    end.

 
