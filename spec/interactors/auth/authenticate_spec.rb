# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auth::Authenticate do
  subject { described_class.call(params: { header: }) }

  let(:valid_to) { 1.day.since }
  let(:session) { create(:auth_session, valid_to:) }
  let(:header) { "Bearer #{session.token}" }

  it do
    is_expected.to be_success
    expect(subject.resource).to eq(session)
  end

  it_behaves_like "failed with error", "header", "must be filled" do
    let(:header) { nil }
  end

  it_behaves_like "failed with error", "header", "is invalid" do
    let(:header) { session.token }
  end

  it_behaves_like "failed with error", "base", "session is not found" do
    let(:header) { "Bearer invalid" }
  end

  it_behaves_like "failed with error", "base", "session is not found" do
    let(:valid_to) { 1.hour.ago }
  end
end
