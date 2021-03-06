# frozen_string_literal: true

require "active_support/core_ext/array/wrap"

module RSpec::ResemblesJsonMatchers
  def resembles(expected)
    ResemblesMatcher.new(expected)
  end

  class ResemblesMatcher
    def initialize(expected, inclusion: nil)
      @expected = expected

      candidate_class = if inclusion == :any
                          ResemblesAnyOfMatcher
                        elsif inclusion == :all
                          ResemblesAllOfMatcher
                        else
                          candidates.detect { |candidate| candidate.can_match?(@expected) }
                        end

      fail "Could not find an acceptable resembles matcher for #{@expected.inspect}" unless candidate_class

      @candidate = candidate_class.new(expected)
    end

    def description
      @candidate.description
    end

    def matches?(actual)
      @actual = actual
      @candidate&.matches?(actual)
    end

    def failure_message(negated: false)
      "expected #{@actual.inspect} to #{negated ? 'not ' : ''}#{description}"
    end

    def negative_failure_message
      failure_message(negated: true)
    end

    def candidates; end
  end

  class ResemblesAllOfMatcher
  end

  RSpec.configure { |c| c.include self }
end
