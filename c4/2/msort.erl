-module(msort).
-compile([export_all]).
-include_lib("eunit/include/eunit.hrl").

sep(L, 0) -> {[], L};
sep([H|T], N) -> {Lleft, Lright} = sep(T, N-1),
  {[H|Lleft], Lright}.

merge([], L) -> L;
merge(L, []) -> L;
merge([X|Xs], [Y|Ys]) ->
  case X < Y of
    true ->[X| merge(Xs, [Y|Ys])];
    false -> [Y| merge([X|Xs], Ys)]
  end.

ms([]) -> [];
ms([A]) -> [A];
ms(L) ->
  {L1, L2} = sep(L, length(L) div 2),
  merge(ms(L1),ms(L2)).

rcvp(Pid) ->
  receive
      {Pid, L} -> L
  end.

pms(L) -> Pid = spawn(?MODULE, p_ms, [self(), L]),
          rcvp(Pid).

p_ms(Pid, L) when length(L) < 100 -> Pid ! {self(), ms(L)};
p_ms(Pid, L) -> {Lleft, Lright} = sep(L, length(L) div 2),
                Pid1 = spawn(?MODULE, p_ms, [self(), Lleft]),
                Pid2 = spawn(?MODULE, p_ms, [self(), Lright]),
                L1 = rcvp(Pid1),
                L2 = rcvp(Pid2),
                Pid ! {self(), merge(L1, L2)}.

%% Tests

random_list(N) -> random_list(N, N, []).
random_list(0, _, L) -> L;
random_list(N, M, L) -> random_list(N-1, M, [random:uniform(M) | L]).

seq1_test() ->
    L = random_list(100),
    chrono(?MODULE, ms, [L]).

seq2_test() ->
    L = random_list(1000000),
    chrono(?MODULE, pms, [L]).

chrono(M, F, P) ->
    {_, Seconds, Micros} = erlang:timestamp(),
    T1 = Seconds + (Micros/1000000.0),
    apply(M, F, P),
    {_, Seconds2, Micros2} = erlang:timestamp(),
    T2 = Seconds2 + (Micros2/1000000.0),
    T2 - T1.
