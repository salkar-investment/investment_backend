# frozen_string_literal: true

RSpec.shared_examples_for "destroy action" do
  include_context "common action context"
  subject { delete :destroy, params: }

  let!(:resource) { create(factory_name) }
  let(:id) { resource.id }
  let(:params) { { id: } }
  let(:permission_action) { "destroy" }
  let(:initial_count) { 1 }

  include_examples "when not authenticated"
  include_examples "when not authorized"
  include_examples "action permission"

  context "when authenticated and authorized", with_auth_stub: true do
    it do
      expect { subject }
        .to change { resource.class.count }
              .from(initial_count).to(initial_count - 1)
      expect(response.status).to eq(204)
    end
  end
end
