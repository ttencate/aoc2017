use buffered = "buffered"
use itertools = "itertools"


interface Runner

  fun apply(startA: U64, startB: U64)


class Parser is StdinNotify

  let _env: Env
  let _run: Runner

  let _reader: buffered.Reader = buffered.Reader.create()

  new create(env: Env, run: Runner) =>
    _env = env
    _run = run

  fun ref apply(data: Array[U8] iso) =>
    _reader.append(consume data)

  fun ref _parseLine(): U64 val ? =>
    try
      let line = _reader.line()?
      let parts = line.split(" ")
      (let value, let _) = parts(4)?.read_int[U64]()?
      value
    else
      error
    end

  fun ref dispose() =>
    try
      let startA = _parseLine()?
      let startB = _parseLine()?
      _run(startA, startB)
    end


class Generator is Iterator[U64]

  let _factor: U64
  var _value: U64

  new create(factor: U64, start: U64) =>
    _factor = factor
    _value = start

  fun ref next(): U64 =>
    _value = (_value * _factor) % 2147483647
    _value

  fun tag has_next(): Bool => true


actor Main

  let _env: Env

  new create(env: Env) =>
    _env = env
    _env.input(recover Parser(env, this~judge()) end)

  be judge(startA: U64, startB: U64) =>
    let generatorA = Generator.create(16807, startA)
    let generatorB = Generator.create(48271, startB)
    var count: U64 = 0
    var matches: U64 = 0
    for (valueA, valueB) in itertools.Iter[U64](generatorA).zip[U64](generatorB) do
      if (valueA and 0xffff) == (valueB and 0xffff) then
        matches = matches + 1
      end
      count = count + 1
      if count == 40_000_000 then
        break
      end
    end
    _env.out.print(matches.string())
