#!/usr/bin/elixir

defmodule Aoc22a do

  def turn_left({dx, dy}) do
    {dy, -dx}
  end

  def turn_right({dx, dy}) do
    {-dy, dx}
  end

  def add({xa, ya}, {xb, yb}) do
    {xa + xb, ya + yb}
  end

  def step({pos, dir, infected, infections}) do
    if MapSet.member?(infected, pos) do
      dir = turn_right(dir)
      {add(pos, dir), dir, MapSet.delete(infected, pos), infections}
    else
      dir = turn_left(dir)
      {add(pos, dir), dir, MapSet.put(infected, pos), infections + 1}
    end
  end

#  def show_infected(infected) do
#    xmin = Enum.reduce(Enum.map(infected, fn({x, _}) -> x end), fn(a, b) -> min(a, b) end)
#    xmax = Enum.reduce(Enum.map(infected, fn({x, _}) -> x end), fn(a, b) -> max(a, b) end)
#    ymin = Enum.reduce(Enum.map(infected, fn({_, y}) -> y end), fn(a, b) -> min(a, b) end)
#    ymax = Enum.reduce(Enum.map(infected, fn({_, y}) -> y end), fn(a, b) -> max(a, b) end)
#    Enum.join(Enum.map(ymin..ymax, fn(y) -> Enum.map(xmin..xmax, fn(x) -> if MapSet.member?(infected, {x, y}) do "#" else "." end end) end), "\n")
#  end

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
        fn({x, char}) -> if char == "#" do {x, y} else nil end end) end),
  fn(element) -> element != nil end)
start_position = {0, 0}
start_direction = {0, -1}
start_infections_count = 0

start_state = {start_position, start_direction, MapSet.new(start_infected), start_infections_count}
path = Stream.iterate(start_state, fn(state) -> Aoc22a.step(state) end)

{_, _, end_infected, end_infections_count} = Enum.at(path, 10000)
# IO.puts(Aoc22a.show_infected(end_infected))
IO.puts(end_infections_count)
