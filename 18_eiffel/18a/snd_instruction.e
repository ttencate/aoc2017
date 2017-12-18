class SND_INSTRUCTION
inherit INSTRUCTION

create {ANY}
  make

feature {ANY}

  make(f: VALUE)
    do
      frequency := f
    end

  execute(state: STATE)
    do
      state.play_sound(frequency.evaluate(state))
      state.increment_pc
    end

feature {}

  frequency: VALUE

end
