class SET_INSTRUCTION
inherit INSTRUCTION

create {ANY}
  make

feature {ANY}

  make(r: STRING; v: VALUE)
    do
      register := r
      value := v
    end

  execute(state: STATE)
    do
      state.set_register(register, value.evaluate(state))
      state.increment_pc
    end

feature {}

  register: STRING
  value: VALUE

end
