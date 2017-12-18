class RCV_INSTRUCTION

inherit
  INSTRUCTION
    redefine
      is_blocked
  end

create {ANY}
  make

feature {ANY}

  make(r: STRING)
    do
      register := r
    end

  is_blocked(state: STATE): BOOLEAN
    do
      Result := not state.can_receive
    end

  execute(state: STATE)
    do
      state.set_register(register, state.receive)
      state.increment_pc
    end

feature {}

  register: STRING

end
