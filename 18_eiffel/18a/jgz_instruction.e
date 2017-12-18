class JGZ_INSTRUCTION
inherit INSTRUCTION

create {ANY}
  make

feature {ANY}

  make(c: VALUE; o: VALUE)
    do
      condition := c
      offset := o
    end

  execute(state: STATE)
    do
      if condition.evaluate(state) > 0 then
        state.set_pc(state.get_pc + offset.evaluate(state))
      else
        state.increment_pc
      end
    end

feature {}

  condition: VALUE
  offset: VALUE

end
