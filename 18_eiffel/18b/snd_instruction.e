class SND_INSTRUCTION
inherit INSTRUCTION

create {ANY}
  make

feature {ANY}

  make(v: VALUE)
    do
      value := v
    end

  execute(state: STATE)
    do
      state.send(value.evaluate(state))
      state.increment_pc
    end

feature {}

  value: VALUE

end
