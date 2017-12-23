#!/usr/bin/elixir

defmodule Aoc22a do

  def turn_left({dx, dy}) do
    {dy, -dx}
  end

  def turn_right({dx, dy}) do
    {-dy, dx}
  end

  def reverse({dx, dy}) do
    {-dx, -dy}
  end

  def add({xa, ya}, {xb, yb}) do
    {xa + xb, ya + yb}
  end

  def step({pos, dir, infected, infections}) do
    case Map.get(infected, pos, ".") do
      "." ->
        dir = turn_left(dir)
        {add(pos, dir), dir, Map.put(infected, pos, "W"), infections}
      "W" ->
        {add(pos, dir), dir, Map.put(infected, pos, "#"), infections + 1}
      "#" ->
        dir = turn_right(dir)
        {add(pos, dir), dir, Map.put(infected, pos, "F"), infections}
      "F" ->
        dir = reverse(dir)
        {add(pos, dir), dir, Map.delete(infected, pos), infections}
    end
  end

end

input = String.split(IO.read(:stdio, :all), "\n")

nx = String.length(hd(input))
ny = length(input)
xs = -div(nx - 1, 2) .. div(nx - 1, 2)
ys = -div(ny - 1, 2) .. div(ny - 1, 2)
start_infected = Stream.filter(
  Stream.flat_map(
    Stream.zip(ys, input),
    fn({y, line}) ->
      Stream.map(
        Stream.zip(xs, String.codepoints(line)),
        fn({x, char}) -> if char != "." do {{x, y}, char} else nil end end) end),
  fn(element) -> element != nil end)
start_position = {0, 0}
start_direction = {0, -1}
start_infections_count = 0

start_state = {start_position, start_direction, Map.new(start_infected), start_infections_count}
path = Stream.iterate(start_state, fn(state) -> Aoc22a.step(state) end)

{_, _, end_infected, end_infections_count} = Enum.at(path, 10000000)
IO.puts(end_infections_count)
