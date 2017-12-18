class REGISTER_VALUE
inherit VALUE

create {ANY}
  make

feature {ANY}

  make(r: STRING)
    do
      register := r
    end

  evaluate(state: STATE): INTEGER_64
    do
      Result := state.get_register(register)
    end

feature {}
  register: STRING

end

