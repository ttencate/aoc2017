class CONSTANT_VALUE
inherit VALUE

create {ANY}
  make

feature {ANY}

  make(v: INTEGER_64)
    do
      value := v
    end

  evaluate(state: STATE): INTEGER_64
    do
      Result := value
    end

feature {}
  value: INTEGER_64

end
