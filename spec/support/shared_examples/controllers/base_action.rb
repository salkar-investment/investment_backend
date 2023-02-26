# frozen_string_literal: true

RSpec.shared_context "common action context" do
  let(:permission_controller) do
    described_class.to_s.gsub("Controller", "").underscore
  end
  let(:permission) do
    create(:auth_permission,
           controller: permission_controller, action: permission_action)
  end
  let(:role) { permission.role }
  let(:user) { create(:auth_user) }
  let(:user_role) { create(:auth_user_role, user:, role:) }
  let(:session) { create(:auth_session, user:) }
  let(:resource_class) do
    parts = controller.class.to_s.sub("Controller", "").split("::")[2..-1]
    class_name = parts.pop.singularize
    parts.push(class_name).join("::").constantize
  end
  let(:factory_name) do
    resource_class.name.underscore.gsub("/", "_").to_sym
  end

  before(when_authenticated: true) do
    request.headers["Authorization"] = "Bearer #{session.token}"
  end

  before auth: true do
    request.headers["Authorization"] = "Bearer #{session.token}"
    user_role
  end

  before with_auth_stub: true do
    allow(controller).to receive_messages(authenticate: true, authorize: true)
  end
end

RSpec.shared_examples_for "when not authenticated" do
  context "when not authenticated" do
    it do
      subject
      expect(response.status).to eq(401)
    end
  end
end

RSpec.shared_examples_for "when not authorized" do
  context "when not authorized", when_authenticated: true do
    it do
      subject
      expect(response.status).to eq(403)
    end
  end
end

RSpec.shared_examples_for "action permission" do
  context "action permission" do
    it do
      expect(
        Auth::AvailablePermissions::Index::PERMISSIONS[
          permission_controller
        ].keys
      ).to include(permission_action)
    end
  end
end
