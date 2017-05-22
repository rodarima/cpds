-module(acceptor).
-export([start/2]).

start(Name, PanelId) ->
    spawn(fun() -> init(Name, PanelId) end).
        
init(Name, PanelId) ->
    Promised = order:null(), 
    Voted = order:null(),
    Value = na,
    acceptor(Name, Promised, Voted, Value, PanelId).

acceptor(Name, Promised, Voted, Value, PanelId) ->
  receive
    {prepare, Proposer, Round} ->
        case order:gr(Round, Promised) of
            true ->
                Proposer ! {promise, Round, Voted, Value},               
                % Update gui
                if
                    Value == na ->
                        Colour = {0,0,0};
                    true ->
                        Colour = Value
                end,                
    io:format("[Acceptor ~w] Phase 1: promised ~w voted ~w colour ~w~n",
                [Name, Promised, Voted, Value]),
                PanelId ! {updateAcc, "Voted: " 
                        ++ io_lib:format("~p", [Voted]), "Promised: " 
                        ++ io_lib:format("~p", [Promised]), Colour},
                acceptor(Name, Promised, Voted, Value, PanelId);
            false ->
                Proposer ! {sorry, {prepare, Round}},
                acceptor(Name, Promised, Voted, Value, PanelId)
        end;
    {accept, Proposer, Round, Proposal} ->
        case order:goe(Round, Promised) of
            true ->
                Proposer ! {vote, Round},
								% XXX: Now Round is the new Voted
                case order:goe(Round, Voted) of
                    true ->
                        % Update gui
    io:format("[Acceptor ~w] Phase 2a: promised ~w voted ~w colour ~w~n",
                        [Name, Promised, Round, Proposal]),
                        PanelId ! {updateAcc, "Voted: " 
                                ++ io_lib:format("~p", [Round]), "Promised: " 
                                ++ io_lib:format("~p", [Promised]), Proposal},
                        acceptor(Name, Promised, Round, Proposal, PanelId);
                    false ->
                        % Update gui
    io:format("[Acceptor ~w] Phase 2b: promised ~w voted ~w colour ~w~n",
                        [Name, Promised, Round, Value]),
                        PanelId ! {updateAcc, "Voted: " 
                                ++ io_lib:format("~p", [Round]), "Promised: " 
                                ++ io_lib:format("~p", [Promised]), Value},
                        acceptor(Name, Promised, Round, Value, PanelId)
                end;                            
            false ->
                Proposer ! {sorry, {accept, Round}},
                acceptor(Name, Promised, Voted, Value, PanelId)
        end;
    stop ->
        PanelId ! stop,
        ok
  end.
