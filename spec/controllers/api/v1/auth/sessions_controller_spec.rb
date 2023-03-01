# frozen_string_literal: true

RSpec.describe Api::V1::Auth::SessionsController, type: :controller do
  describe "#create" do
    subject do
      post :create, params: { resource: { email:, password: } }
    end

    let(:email) { "test@example.org" }
    let(:password) { "test" }
    let!(:user) { create(:auth_user, :with_password, email:, password: "test") }

    it do
      expect { subject }.to change { Auth::Session.count }.from(0).to(1)
      session = Auth::Session.last
      expect(response.status).to eq(201)
      expect(JSON.parse(response.body))
        .to eq("token" => session.token, "valid_to" => session.valid_to.iso8601)
    end

    context "on failure" do
      let(:password) { "invalid" }

      it do
        expect { subject }.not_to change { Auth::Session.count }.from(0)
        expect(response.status).to eq(422)
        expect(response.parsed_body["errors"])
          .to contain_exactly("key" => "base",
                              "value" => "Credentials invalid")
      end
    end
  end

  describe "#destroy" do
    include_context "common action context"
    subject { delete :destroy }

    include_examples "when not authenticated"

    context "when authenticated", when_authenticated: true do
      it do
        expect { subject }.to change { Auth::Session.count }.from(1).to(0)
        expect(response.status).to eq(204)
      end
    end
  end
end
