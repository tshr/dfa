DFA.rb
======

Class to create deterministic finite automata. Just pass in the states,
whether they are accept or start states, and a hash representing the transition function,
and it returns an object that tests strings for whether they result in an accept state.

Example:

transition_hash = {
       "s1" => {"0" => "s1", "1" => "s2"},
       "s2" => {"0" => "s2", "1" => "s1"}
}

foo = DFA.new([State.new("s1", true, true), State.new("s2", false, false)], transition_hash)

This creates a DFA composed of two states (s1, and s2) where s1 is both the start state
and the only accept state. The DFA's alphabet is {0,1} and 1's cause the state to change.
This matches the language of strings of 0 and 1 where there are an even number of 1's. E.g.

foo.accepts?("1010101") #=> true
foo.accepts?("101010") #=> false
foo.compute_final_state("1010101") #=> <struct State name="s1", is_start=true, is_accept=true>
