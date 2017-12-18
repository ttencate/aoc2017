deferred class INSTRUCTION

feature {ANY}

  is_blocked(state: STATE): BOOLEAN
    do
      Result := False
    end

  execute(state: STATE)
    deferred
    end

end
