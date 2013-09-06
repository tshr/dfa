=begin

  Class to create deterministic finite automata. You pass in the states,
  whether they are accept or start states, and a hash representing the transition function

  Example:

  transition_hash = {
         "s1" => {"0" => "s1", "1" => "s2"},
         "s2" => {"0" => "s2", "1" => "s1"}
  }

  foo = DFA.new([State.new("s1", true, true), State.new("s2", false, false)], transition_hash)

  This creates a DFA composed of two states (s1, and s2) where s1 is both the start state
  and the only accept state. The DFA's alphabet is {0,1} and 1's cause the state to change
  This matches the language of strings of 0 and 1 where there are an even number of 1's. E.g.

  foo.accepts?("1010101") # => true
  foo.accepts?("101010") # => false
  foo.compute_final_state("1010101") # => #<struct State name="s1", is_start=true, is_accept=true>

=end

State = Struct.new(:name, :is_start, :is_accept)

class DFA

  attr_reader :states, :initial_state, :transition_hash

  def initialize(states, transition_hash)

    @states = states
    @initial_state = states.select{|s| s.is_start}.first
    @transition_hash = transition_hash

  end

  def accept_states
    @states.select{|s| s.is_accept}
  end

  def compute_final_state(string)
    string.split("").inject(@initial_state) { |state, ch| compute_next_state(state, ch) }
  end

  def accepts?(string)
    compute_final_state(string).is_accept
  end

  private

  def get_state_by_name(name)
    raise "State with name #{name} could not be found" unless state = @states.select{|s| s.name == name}.first
    state
  end

  def compute_next_state(current_state, character)
    if next_state_name = @transition_hash[current_state.name] && @transition_hash[current_state.name][character]
      get_state_by_name next_state_name
    else
      raise "Could not calculate the next state's name with inputs -- state: #{current_state} and character: #{character}"
    end
  end

end
