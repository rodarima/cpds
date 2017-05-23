-module(acceptor).
-export([start/2]).

start(Name, PanelId) ->
    spawn(fun() -> init(Name, PanelId) end).
        
init(Name, PanelId) ->
    MaxRound = order:null(),
    BestVoted = order:null(),
    BestColor = na,
    acceptor(Name, MaxRound, BestVoted, BestColor, PanelId).

acceptor(Name, MaxRound, BestVoted, BestColor, PanelId) ->
	receive
		{prepare, ProposerId, NewRound} ->

			io:format("[Acceptor ~w] received a new round ~w from ~w. Max round is ~w~n",
				[Name, ProposerId, NewRound, MaxRound]),
				
			case order:gr(NewRound, MaxRound) of
			true ->

				% XXX Now MaxRound := NewRound but 
				% I CAN'T SET THE FUCKING VARIABLE IN THIS CRAPPY LANGUAGE

				NewMaxRound = NewRound,
				ProposerId ! {promise, NewMaxRound, BestVoted, BestColor},

				% What IS THIS SHIT? WHY A FUCKING acceptor SHOULD CARE ABOUT GUI PROBLEMS?
				% The person who wrote this code should burn in hell...

				% Update gui
				if
					BestColor == na ->
						Colour = {0,0,0};
					true ->
						Colour = BestColor
				end,								

				% Meaningful information...
				io:format("[Acceptor ~w] Phase 1: got a better MaxRound ~w~n",
					[Name, NewMaxRound]),
				
				PanelId ! {
					updateAcc, 
					io_lib:format("BestVoted ~p", [BestVoted]),
					io_lib:format("MaxRound ~p", [NewMaxRound]),
					Colour
				},

				% Loop the acceptor with the new MaxRound
				acceptor(Name, NewMaxRound, BestVoted, BestColor, PanelId);

			% In case NewRound is worse, reply with sorry
			false ->
				ProposerId ! {sorry, {prepare, NewRound}},

				% Keep the MaxRound as it is better
				acceptor(Name, MaxRound, BestVoted, BestColor, PanelId)
			end;

		% -------------------------------------------------------------------------

		{accept, ProposerId, NewRound, NewColor} ->

			io:format("[Acceptor ~w] received accept with NewRound=~w, NewColor=~w from ~w~n",
				[Name, NewRound, NewColor, ProposerId]),

			% If the new message contains a NewRound >= MaxRound
			case order:goe(NewRound, MaxRound) of
			true ->
				
				NewMaxRound = NewRound,

				% Then vote using the round as identifier
				ProposerId ! {vote, NewMaxRound},

				case order:goe(NewMaxRound, BestVoted) of
				true ->
					NewBestColor = NewColor,
					NewBestVoted = NewMaxRound,

					io:format("[Acceptor ~w] Phase 2a: MaxRound=~w BestVoted=~w Color=~w~n",
						[Name, NewMaxRound, NewBestVoted, NewBestColor]),

					% Update gui
					PanelId ! {
						updateAcc,
						io_lib:format("BestVoted: ~p", [NewBestVoted]),
						io_lib:format("MaxRound: ~p", [NewMaxRound]),
						NewBestColor
					},

					acceptor(Name, NewMaxRound, NewBestVoted, NewBestColor, PanelId);

				false ->

					% The NewMaxRound don't improve our BestVoted

					io:format("[Acceptor ~w] Phase 2b: MaxRound=~w BestVoted=~w Color=~w~n",
						[Name, NewMaxRound, BestVoted, BestColor]),

					% Update gui
					PanelId ! {
						updateAcc,
						io_lib:format("BestVoted: ~p", [BestVoted]),
						io_lib:format("MaxRound: ~p", [NewMaxRound]),
						BestColor
					},

					acceptor(Name, NewMaxRound, BestVoted, BestColor, PanelId)
				end;							

			% If NewRound < MaxRound, send sorry and ignore
			false ->
				ProposerId ! {sorry, {accept, NewRound}},
				acceptor(Name, MaxRound, BestVoted, BestColor, PanelId)
			end;

		% -------------------------------------------------------------------------

		stop ->
			PanelId ! stop,
			ok
		end.
