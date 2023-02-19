# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  let(:session) { create(:auth_session) }
  let(:header) { "Bearer #{session.token}" }
  let(:controller) { "anonymous" }
  let(:action) { "index" }
  let!(:permission) { create(:auth_permission, controller:, action:) }
  let!(:user_role) do
    create(:auth_user_role, user: session.user, role: permission.role)
  end

  controller do
    def index
      head :ok
    end
  end

  describe "#authentication" do
    subject do
      request.headers["Authorization"] = header
      get :index
      response.status
    end

    it do
      expect(::Auth::Authenticate)
        .to receive(:call).with(params: { header: }).and_call_original
      is_expected.to eq(200)
    end

    context "without header" do
      let(:header) { "Bearer invalid" }

      it do
        is_expected.to eq(401)
      end
    end
  end

  describe "#authorization" do
    subject do
      request.headers["Authorization"] = header
      get :index
      response.status
    end

    it do
      expect(::Auth::Authorize)
        .to receive(:call)
        .with(params: { controller:, action:, user_id: session.user_id })
        .and_call_original
      is_expected.to eq(200)
    end

    context "without user role" do
      let(:user_role) { nil }

      it do
        is_expected.to eq(403)
      end
    end
  end
end
