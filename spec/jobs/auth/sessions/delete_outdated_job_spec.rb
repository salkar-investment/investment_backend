# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auth::Sessions::DeleteOutdatedJob do
  subject { described_class.new.perform }

  let(:valid_to) { 1.hour.ago }
  let!(:session) { create(:auth_session, valid_to:) }

  it do
    expect { subject }.to change { Auth::Session.count }.from(1).to(0)
  end

  context "if session is valid" do
    let(:valid_to) { 1.hour.since }

    it do
      expect { subject }.not_to change { Auth::Session.count }.from(1)
    end
  end
end
