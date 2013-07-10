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
    !!compute_final_state(string).is_accept
  end

  private

  def get_state_by_name(name)
    @states.select{|s| s.name == name}.first
  end

  def compute_next_state(current_state, character)
    get_state_by_name @transition_hash[current_state.name][character]
  end

end