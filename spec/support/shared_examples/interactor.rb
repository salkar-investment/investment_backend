# frozen_string_literal: true

RSpec.shared_examples_for "failed with error" do |key, value, meta = nil|
  it do
    is_expected.to be_failure
    expected_error = { key:, value:, meta: }.compact
    expect(subject.errors).to contain_exactly(expected_error)
  end
end
