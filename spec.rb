require 'minitest/spec'
require 'minitest/autorun'
require './dfa.rb'

describe DFA do

  describe "with valid transition hash" do
    before do

      transition_hash = {
        "s1" => {"0" => "s1", "1" => "s2"},
        "s2" => {"0" => "s2", "1" => "s1"}
      }

      @dfa = DFA.new([State.new("s1", true, true), State.new("s2", false, false)], transition_hash)
    end

    it "returns the correct acceptance states" do
      @dfa.accept_states.length.must_equal 1
      @dfa.accept_states.first.name.must_equal "s1"
    end

    it "returns correct final state" do
      Array.new(10).size.must_equal 10
    end

    describe "when matching a valid string" do

      before do
        @accept_test_string = "011010100011"
        @reject_test_string = "011010100010"
      end

      it "accepts a string with an even number of 1s" do
        @dfa.accepts?(@accept_test_string).must_equal true
      end

      it "rejects a string with an odd number of 1s" do
        @dfa.accepts?(@reject_test_string).must_equal false
      end

      it "returns the correct final state" do
        @dfa.compute_final_state(@accept_test_string).name.must_equal "s1"
        @dfa.compute_final_state(@reject_test_string).name.must_equal "s2"
      end

    end

    it "raises an exception when passed an invalid string" do
      exception = assert_raises(RuntimeError) {@dfa.accepts?("a")}
      exception.message.must_include "Could not calculate the next state's name with inputs"
    end
  end

  describe "with invalid transition hash" do

    before do

      @transition_hash = {
        "s1" => {"0" => "s1", "1" => "nonexistant state"}
      }

    end

    it "raises an exception when it can't find a given state by name" do
      dfa = DFA.new([State.new("s1", true, true)], @transition_hash)
      exception = assert_raises(RuntimeError) {dfa.accepts?("1")}
      exception.message.must_include "State with name nonexistant state could not be found"
    end

    it "raises an exception when it doesn't have a transitions hash for a given state's name" do
      dfa = DFA.new([State.new("s2", true, true)], @transition_hash)
      exception = assert_raises(RuntimeError) {dfa.accepts?("1")}
      exception.message.must_include "Could not calculate the next state's name with inputs"
    end

  end
end