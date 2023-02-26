# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Auth::RolesController, type: :controller do
  let(:serialized_resource) do
    { "id" => resource.id, "name" => resource.name }
  end

  it_behaves_like "create action" do
    let(:success_params) { { name: "Role" } }
  end

  it_behaves_like "index action"

  it_behaves_like "show action"

  it_behaves_like "update action" do
    let(:success_params) { { name: "Other name" } }
  end

  it_behaves_like "destroy action"
end
