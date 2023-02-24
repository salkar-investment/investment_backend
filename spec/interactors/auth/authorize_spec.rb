# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auth::Authorize do
  subject { described_class.call(params:) }

  let(:session) { create(:auth_session) }
  let(:controller) { permission.controller }
  let(:action) { permission.action }
  let(:user_id) { session.user_id }
  let!(:permission) { create(:auth_permission) }
  let!(:user_role) do
    create(:auth_user_role, user: session.user, role: permission.role)
  end
  let(:params) { { controller:, action:, user_id: } }

  it do
    is_expected.to be_success
    expect(subject.resource.permissions).to contain_exactly(permission)
    expect(subject.resource.modifiers).to contain_exactly("email")
  end

  context "when multiple permissions available" do
    let!(:permission_1) do
      create(:auth_permission,
             controller:, action:, modifiers: %w[email other])
    end
    let!(:user_role_1) do
      create(:auth_user_role, user: session.user, role: permission_1.role)
    end

    it do
      is_expected.to be_success
      expect(subject.resource.permissions).to contain_exactly(permission,
permission_1)
      expect(subject.resource.modifiers).to contain_exactly("email", "other")
    end
  end

  it_behaves_like "failed with error", "base", "no permissions available" do
    let(:action) { "create" }
  end

  it_behaves_like "failed with error", "base", "no permissions available" do
    let(:controller) { "api/v1/other" }
  end

  it_behaves_like "failed with error", "base", "no permissions available" do
    let(:user_role) { nil }
  end
end
