class Transition(var writeValue: Int = 0, var moveDirection: Int = 0, var nextState: String = "")

class State(val transitions: MutableMap<Int, Transition> = mutableMapOf())

val states = mutableMapOf<String, State>()
var currentState = ""
val tape = mutableMapOf<Int, Int>()
var currentPos = 0
var steps = 0

class MatchSequence(private val line: CharSequence) {
    var matched = false
        private set
    infix fun String.then(fn: (MatchResult.Destructured) -> Unit) {
        if (!matched) {
            Regex(this).matchEntire(line)?.also {
                fn(it.destructured)
                matched = true
            }
        }
    }
}

fun CharSequence.matchRegexes(fn: MatchSequence.() -> Unit) {
    if (!MatchSequence(this).apply(fn).matched) {
        throw RuntimeException("Line ${this} did not match any regex")
    }
}

var state: State? = null
var transition: Transition? = null
System.`in`.bufferedReader().lines().map(String::trim).filter(String::isNotEmpty).forEach { line ->
    line.matchRegexes {
        """Begin in state (.*)\.""" then { (startState) ->
            currentState = startState
        }
        """Perform a diagnostic checksum after (\d+) steps\.""" then { (stepsStr) ->
            steps = stepsStr.toInt()
        }
        """In state (.*):""" then { (stateName) ->
            state = State()
            states[stateName] = state!!
        }
        """If the current value is (\d+):""" then { (currentValueStr) ->
            transition = Transition()
            state!!.transitions[currentValueStr.toInt()] = transition!!
        }
        """- Write the value (\d+)\.""" then { (writeValueStr) ->
            transition!!.writeValue = writeValueStr.toInt()
        }
        """- Move one slot to the (.*)\.""" then { (directionStr) ->
            when (directionStr) {
                "left" -> transition!!.moveDirection = -1
                "right" -> transition!!.moveDirection = 1
            }
        }
        """- Continue with state (.*)\.""" then { (nextState) ->
            transition!!.nextState = nextState
        }
    }
}

fun Transition.run() {
    tape[currentPos] = writeValue
    currentPos += moveDirection
    currentState = nextState
}

for (i in 0..steps) {
    states[currentState]!!.transitions[tape[currentPos] ?: 0]!!.run()
}

println(tape.values.count { it == 1 })