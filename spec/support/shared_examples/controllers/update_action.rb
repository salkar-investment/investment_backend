# frozen_string_literal: true

RSpec.shared_examples_for(
  "update action"
) do |optional_params: [],
      separate_schema_errors: [],
      uniq_scopes: []|
  include_context "common action context"
  subject { put :update, params: { id:, resource: params } }

  let!(:resource) { create(factory_name) }
  let(:id) { resource.id }
  let(:params) do
    success_params.transform_values do |val|
      val.class.in?([Date, DateTime]) ? val.iso8601 : val
    end
  end
  let(:success_params) { {} }
  let(:success_expected_attrs) { success_params }
  let(:failure_params) { success_params.transform_values { |_val| nil } }
  let(:expected_errors) do
    failure_params.except(*(optional_params || [])).map do |k, _v|
      { "key" => "resource.#{k}", "value" => "must be filled" }
    end
  end
  let(:permission_action) { "update" }

  include_examples "when not authenticated"
  include_examples "when not authorized"
  include_examples "action permission"

  context "when authenticated and authorized", with_auth_stub: true do
    it do
      subject
      resource.reload
      success_expected_attrs.each do |k, v|
        expect(resource.public_send(k)).to eq(v)
      end
      expect(response.status).to eq(204)
    end

    if separate_schema_errors.present?
      separate_schema_errors.each do |fields|
        context "if validation failed for (#{fields.join(', ')}) fields" do
          let(:params) do
            success_params.to_h { |k, v| [k, k.in?(fields) ? nil : v] }
          end
          let(:expected_errors) do
            params.slice(*fields).map do |k, _v|
              { "key" => "resource.#{k}", "value" => "must be filled" }
            end
          end

          it_behaves_like "validation failed on update action"
        end
      end
    else
      context "if validation failed" do
        let(:params) { failure_params }

        it_behaves_like "validation failed on update action"
      end
    end

    context "if relations are not found" do
      let(:relation_keys) do
        success_params.keys.select { |k| k.end_with?("_id") }
      end
      let(:params) do
        success_params.to_h { |k, v| [k, k.in?(relation_keys) ? 0 : v] }
      end
      let(:expected_errors) do
        relation_keys.map do |k|
          { "key" => "resource.#{k}", "value" => "must exist" }
        end
      end

      it_behaves_like("validation failed on update action",
                      skip_without_expected_errors: true)
    end

    uniq_scopes.each do |uniq_scope|
      context "if uniq validation failed" do
        let!(:prev_resource) do
          create(factory_name, success_expected_attrs.slice(*uniq_scope))
        end
        let(:expected_errors) do
          [{ "key" => "resource.#{uniq_scope.first}",
             "value" => "has already been taken" }]
        end

        it_behaves_like("validation failed on update action")
      end
    end
  end
end

RSpec.shared_examples_for(
  "validation failed on update action"
) do |skip_without_expected_errors: false|
  it do
    next if skip_without_expected_errors && expected_errors.blank?

    expect { subject }.not_to change { resource.reload.updated_at }
    expect(response.status).to eq(422)
    expect(response.parsed_body["errors"])
      .to match_array(expected_errors)
  end
end
