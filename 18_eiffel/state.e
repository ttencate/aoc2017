class STATE

create {ANY}
  initial

feature {ANY}

  initial(p: ARRAY[INSTRUCTION])
    do
      program := p
      create registers
    end

  get_register(r: STRING): INTEGER_64
    do
      if registers.has(r) then
        Result := registers@r
      else
        Result := 0
      end
    end

  set_register(r: STRING; v: INTEGER_64)
    do
      registers.put(v, r)
    ensure
      register_is_set: get_register(r) = v
    end

  get_next_instruction: INSTRUCTION
    require
      not_done: not is_done
    do
      Result := program @ pc.to_integer_32
    end

  get_pc: INTEGER_64
    require
      not_done: not is_done
    do
      Result := pc
    end

  set_pc(ni: INTEGER_64)
    require
      not_done: not is_done
    do
      if ni.fit_integer_32 and program.valid_index(ni.to_integer_32) then
        pc := ni
      else
        set_done
      end
    end

  increment_pc
    require
      not_done: not is_done
    do
      set_pc(get_pc + 1)
    end

  get_last_sound_frequency: INTEGER_64
    do
      Result := last_sound_frequency
    end

  play_sound(f: INTEGER_64)
    require
      not_done: not is_done
    do
      last_sound_frequency := f
    end

  set_done
    do
      done := True
    end

  is_done: BOOLEAN
    do
      Result := done
    end

feature {}

  program: ARRAY[INSTRUCTION]
  pc: INTEGER_64
  registers: HASHED_DICTIONARY[INTEGER_64, STRING]
  last_sound_frequency: INTEGER_64
  done: BOOLEAN

end
