class RCV_INSTRUCTION
inherit INSTRUCTION

create {ANY}
  make

feature {ANY}

  make(r: STRING)
    do
      register := r
    end

  execute(state: STATE)
    do
      if state.get_register(register) /= 0 then
        state.set_register(register, state.get_last_sound_frequency)
        state.set_done
      else
        state.increment_pc
      end
    end

feature {}

  register: STRING

end
