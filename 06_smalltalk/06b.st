#!/usr/bin/gst -f

state := ((stdin nextLine subStrings: '	') collect: [:string | string asNumber]) asArray.
banks := state size.

seenStates := LookupTable new.
count := 0.

[seenStates includesKey: state] whileFalse: [
  seenStates at: (state copy) put: count.
  count := count + 1.

  "Find bank to redistribute"
  max := 0.
  redistributeIndex := 0.
  state keysAndValuesDo: [:i :blocks |
    (blocks > max) ifTrue: [
      max := blocks.
      redistributeIndex := i.
    ].
  ].
  
  "Redistribute bank"
  redistributedBlocks := state at: redistributeIndex.
  state at: redistributeIndex put: 0.
  blocksForEachBank := redistributedBlocks // banks.
  remainingBlocks := redistributedBlocks \\ banks.
  state := (state collect: [:blocks |
    blocks + blocksForEachBank
  ]) asArray.
  1 to: remainingBlocks do: [:i |
    index := ((redistributeIndex + i - 1) \\ banks) + 1.
    state at: index put: ((state at: index) + 1).
  ].
].

(count - (seenStates at: state)) printNl.
