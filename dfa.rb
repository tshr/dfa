State = Struct.new(:name, :is_start, :is_accept)

class DFA

  attr_reader :states, :initial_state, :transition_hash

  def initialize(states, transition_hash)
    @states = states
    @initial_state = states.select{|s| s.is_start}.first
    @transition_hash = transition_hash
  end

  def accepts?(string)

    current_state = @initial_state
    string.each_char do |ch|
      current_state = get_state_by_name(@transition_hash[current_state.name][ch])
    end

    !!current_state.is_accept
  end

  private

  def get_state_by_name(name)
    @states.select{|s| s.name == name}.first
  end

end

# @@test_transition_hash = {

#   "s1" => {"0" => "s2", "1" => "s1"},
#   "s2" => {"0" => "s1", "1" => "s2"}

# }

# @@test_dfa = DFA.new([State.new("s1", true, true), State.new("s2", false, false)], @@test_transition_hash)

# maybe use inject instead of each_char
# validations
# final state method
# tests