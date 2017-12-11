-module(aoc10b).

-export([start/0, element/1, dest_index/4]).

dest_index(Marks, Index, Position, Length) ->
  if
    (Index - Position + Marks) rem Marks < Length ->
      (Position + Length - 1 - (Index - Position) + Marks) rem Marks;
    true ->
      Index
  end.

element(Index) ->
  receive
    {pids, Pids} ->
      element(Pids, Index, Index, 0, 0)
  end.

element(Pids, Index, Value, Position, Skip) ->
  Marks = length(Pids),
  %io:format("Element ~w has value ~w (position = ~w, skip = ~w)~n", [Index, Value, Position, Skip]),
  receive
    {length, Length, MainPid} ->
      DestIndex = dest_index(Marks, Index, Position, Length),
      %io:format("Element ~w sending ~w to element dest_index(~w, ~w, ~w, ~w) = ~w~n", [Index, Value, Marks, Index, Position, Length, DestIndex]),
      lists:nth(DestIndex + 1, Pids) ! {value, Value},
      receive
        {value, NewValue} ->
          NewPosition = (Position + Length + Skip) rem Marks,
          NewSkip = Skip + 1,
          MainPid ! done,
          element(Pids, Index, NewValue, NewPosition, NewSkip)
      end;
    {report, Pid} ->
      Pid ! {result, Index, Value}
  end.

broadcast(Pids, Message) ->
  %io:format("~w~n", [Length]),
  lists:foreach(fun(Pid) -> Pid ! Message end, Pids).

wait_done(0) ->
  true;
wait_done(N) ->
  receive
    done ->
      wait_done(N - 1)
  end.

get_results([], Acc) ->
  lists:map(fun({_, Value}) -> Value end, lists:sort(Acc));
get_results([Pid | Pids], Acc) ->
  Pid ! {report, self()},
  receive
    {result, Index, Value} ->
      get_results(Pids, [{Index, Value} | Acc])
  end.

segmentize(_, []) ->
  [];
segmentize(N, List) ->
  {Head, Tail} = lists:split(N, List),
  [ Head | segmentize(N, Tail) ].

start() ->
  Input = string:chomp(io:get_line("")),
  Lengths = lists:flatten(lists:duplicate(64, lists:append(Input, [17, 31, 73, 47, 23]))),
  %io:format("~w~n", [Lengths]),
  Marks = 256,
  Pids = lists:map(fun(Index) -> spawn(aoc10b, element, [Index]) end, lists:seq(0, Marks - 1)),
  broadcast(Pids, {pids, Pids}),
  lists:foreach(fun(Length) ->
                    broadcast(Pids, {length, Length, self()}),
                    wait_done(Marks)
                end,
                Lengths),
  broadcast(Pids, {report, self()}),
  Results = get_results(Pids, []),
  Segments = segmentize(16, Results),
  Numbers = lists:map(fun(Segment) -> lists:foldl(fun(A, B) -> A bxor B end, 0, Segment) end, Segments),
  Hexes = lists:flatten(lists:map(fun(Number) -> io_lib:format("~2.16.0b", [Number]) end, Numbers)),
  io:format("~s~n", [Hexes]),
  halt().
