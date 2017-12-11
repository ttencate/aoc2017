-module(aoc10a).

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
  % BUGGY! See README.md for details.
  io:format("Element ~w has value ~w (position = ~w, skip = ~w)~n", [Index, Value, Position, Skip]),
  receive
    {length, Length} ->
      DestIndex = dest_index(Marks, Index, Position, Length),
      io:format("Element ~w sending ~w to element dest_index(~w, ~w, ~w, ~w) = ~w~n", [Index, Value, Marks, Index, Position, Length, DestIndex]),
      lists:nth(DestIndex + 1, Pids) ! {value, Value},
      receive
        {value, NewValue} ->
          NewPosition = (Position + Length + Skip) rem Marks,
          NewSkip = Skip + 1,
          element(Pids, Index, NewValue, NewPosition, NewSkip)
      end;
    {report, Pid} ->
      Pid ! {result, Value}
  end.

get_result(Pid) ->
  Pid ! {report, self()},
  receive
    {result, Value} ->
      Value
  end.

start() ->
  Input = string:chomp(io:get_line("")),
  ParseInt = fun(String) -> {Int, _} = string:to_integer(String), Int end,
  Lengths = lists:map(ParseInt, string:tokens(Input, ",")),
  Marks = 256,
  Pids = lists:map(fun(Index) -> spawn(aoc10a, element, [Index]) end, lists:seq(0, Marks - 1)),
  lists:foreach(fun(Pid) -> Pid ! {pids, Pids} end, Pids),
  lists:foreach(fun(Length) -> lists:foreach(fun(Pid) -> Pid ! {length, Length} end, Pids) end, Lengths),
  Answer = get_result(lists:nth(1, Pids)) * get_result(lists:nth(2, Pids)),
  io:format("~w~n", [Answer]),
  halt().
