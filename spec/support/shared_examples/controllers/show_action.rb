# frozen_string_literal: true

RSpec.shared_examples_for "show action" do
  include_context "common action context"
  subject { get :show, params: { id: } }

  let!(:resource) { create(factory_name) }
  let(:id) { resource.id }
  let(:expected_result) { serialized_resource }
  let(:permission_action) { "show" }

  include_examples "when not authenticated"
  include_examples "when not authorized"
  include_examples "action permission"

  context "when authenticated and authorized", with_auth_stub: true do
    it do
      subject
      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq(expected_result)
    end
  end
end
