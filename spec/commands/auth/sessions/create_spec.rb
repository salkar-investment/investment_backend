# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Auth::Sessions::Create do
  subject { described_class.call(params: { resource: { email:, password: } }) }

  let(:user_password) { "test" }
  let(:password_attempts_left) { 20 }
  let(:password_valid_to) { 1.day.since }
  let!(:user) do
    create(:auth_user, password: user_password,
                       password_attempts_left:,
                       password_valid_to:)
  end
  let(:email) { user.email }
  let(:password) { user_password }
  let(:credentials_invalid_error) do
    [{ key: "base", value: "Credentials invalid" }]
  end

  it do
    is_expected.to be_success
  end

  it do
    travel_to Time.current.beginning_of_minute do
      expect { subject }.to change { Auth::Session.count }.from(0).to(1)
      session = Auth::Session.last
      expect(subject.resource).to eq(session)
      expect(session.token.size).to be > described_class::TOKEN_BYTE_LENGTH
      expect(session.valid_to).to eq(described_class::SESSION_VALID.since)
      expect(session.user).to eq(user)
      expect(user.reload.password_digest).to be_nil
      expect(user.password_attempts_left).to be_nil
      expect(user.password_valid_to).to be_nil
    end
  end

  context "if email is not in downcase" do
    let(:email) { user.email.upcase }

    it do
      is_expected.to be_success
    end
  end

  context "if password expired" do
    let(:password_valid_to) { 1.minute.ago }

    it do
      is_expected.to be_failure
      expect(subject.errors).to eq(credentials_invalid_error)
    end
  end

  context "if sign in attempts left" do
    let(:password_attempts_left) { 0 }

    it do
      is_expected.to be_failure
      expect(subject.errors).to eq(credentials_invalid_error)
    end
  end

  context "if password does not match" do
    let(:password) { "invalid" }

    it do
      is_expected.to be_failure
      expect(subject.errors).to eq(credentials_invalid_error)
      expect(user.reload.password_attempts_left)
        .to eq(password_attempts_left - 1)
    end
  end

  context "if user does not exists" do
    let(:email) { "invalid@example.org" }

    it do
      is_expected.to be_failure
      expect(subject.errors).to eq(credentials_invalid_error)
    end
  end

  context "if token exists" do
    let(:first_token) { "1" }
    let(:second_token) { "2" }
    let!(:session) { create(:auth_session, token: first_token) }

    before do
      allow(SecureRandom)
        .to receive(:urlsafe_base64).and_return(first_token, second_token)
    end

    it do
      expect { subject }.to change { Auth::Session.count }.from(1).to(2)
      expect(subject.resource.token).to eq(second_token)
    end
  end

  it_behaves_like "failed with error", "resource.email", "must be filled" do
    let(:email) { nil }
  end

  it_behaves_like "failed with error", "resource.password", "must be filled" do
    let(:password) { nil }
  end
end
