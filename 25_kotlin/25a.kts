class Transition(var writeValue: Int = 0, var moveDirection: Int = 0, var nextState: String = "")

class State(val transitions: MutableMap<Int, Transition> = mutableMapOf())

val states = mutableMapOf<String, State>()
var currentState = ""
val tape = mutableMapOf<Int, Int>()
var currentPos = 0
var steps = 0

fun CharSequence.ifMatches(regex: String, fn: (MatchResult.Destructured) -> Unit): Boolean {
    val result = Regex(regex).matchEntire(this)
    if (result != null) {
        fn(result.destructured)
        return true
    }
    return false
}

var state: State? = null
var transition: Transition? = null
for (line in System.`in`.bufferedReader().lines().map(String::trim)) {
    if (line.isEmpty()) {
        continue
    }
    line.apply {
        ifMatches("""Begin in state (.*)\.""") { (startState) ->
            currentState = startState
        } ||
        ifMatches("""Perform a diagnostic checksum after (\d+) steps\.""") { (stepsStr) ->
            steps = stepsStr.toInt()
        } ||
        ifMatches("""In state (.*):""") { (stateName) ->
            state = State()
            states[stateName] = state!!
        } ||
        ifMatches("""If the current value is (\d+):""") { (currentValueStr) ->
            transition = Transition()
            state!!.transitions[currentValueStr.toInt()] = transition!!
        } ||
        ifMatches("""- Write the value (\d+)\.""") { (writeValueStr) ->
            transition!!.writeValue = writeValueStr.toInt()
        } ||
        ifMatches("""- Move one slot to the (.*)\.""") { (directionStr) ->
            when (directionStr) {
                "left" -> transition!!.moveDirection = -1
                "right" -> transition!!.moveDirection = 1
            }
        } ||
        ifMatches("""- Continue with state (.*)\.""") { (nextState) ->
            transition!!.nextState = nextState
        } ||
        throw RuntimeException("Could not parse line ${this}")
    }
}

for (i in 0..steps) {
    val state = states[currentState]!!
    val currentValue = tape[currentPos] ?: 0
    val transition = state.transitions[currentValue]!!
    tape[currentPos] = transition.writeValue
    currentPos += transition.moveDirection
    currentState = transition.nextState
}

println(tape.values.count { it == 1 })