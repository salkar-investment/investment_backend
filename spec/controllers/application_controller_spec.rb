# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  let(:session) { create(:auth_session) }
  let(:header) { "Bearer #{session.token}" }

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
end
