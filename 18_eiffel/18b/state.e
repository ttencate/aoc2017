class STATE

create {ANY}
  initial

feature {ANY}

  initial(p: ARRAY[INSTRUCTION]; index: INTEGER_64)
    do
      program := p
      create queue.make
      create registers
      set_register("p", index)
    end

  set_peer(p: STATE)
    do
      peer := p
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
      pc := ni
    end

  increment_pc
    require
      not_done: not is_done
    do
      set_pc(get_pc + 1)
    end

  send(v: INTEGER_64)
    require
      has_peer: peer /= Void
    do
      peer.enqueue(v)
      send_count := send_count + 1
    end

  can_receive: BOOLEAN
    do
      Result := not queue.is_empty
    end

  receive: INTEGER_64
    require
      can_receive: can_receive
    do
      Result := queue.first
      queue.remove
    end

  is_blocked: BOOLEAN
    do
      if is_done then
        Result := True
      else
        Result := get_next_instruction.is_blocked(Current)
      end
    end

  maybe_execute
    do
      if not is_blocked then
        get_next_instruction.execute(Current)
      end
    end

  is_done: BOOLEAN
    do
      if not pc.fit_integer_32 then
        Result := False
      else
        Result := not program.valid_index(pc.to_integer_32)
      end
    end

  get_send_count: INTEGER
    do
      Result := send_count
    end

feature {STATE}

  enqueue(v: INTEGER_64)
    do
      queue.add(v)
    end

feature {}

  program: ARRAY[INSTRUCTION]
  peer: STATE

  pc: INTEGER_64
  registers: HASHED_DICTIONARY[INTEGER_64, STRING]
  queue: QUEUE[INTEGER_64]
  send_count: INTEGER

  get_next_instruction: INSTRUCTION
    require
      not_done: not is_done
    do
      Result := program @ pc.to_integer_32
    end

end
