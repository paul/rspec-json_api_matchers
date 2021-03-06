# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe RSpec::ResemblesJsonMatchers do
  subject do
    Class.new { include RSpec::ResemblesJsonMatchers }.new
  end

  specify { expect(subject.match_json({})).to be_a_matcher }
  specify { expect(subject.resemble_json({})).to be_a_matcher }

  # Support

  matcher :be_a_matcher do
    match do |actual|
      actual.respond_to? :matches?
    end
  end
end
