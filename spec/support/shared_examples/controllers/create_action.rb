# frozen_string_literal: true

RSpec.shared_examples_for(
  "create action"
) do |separate_schema_errors: [],
      optional_params: [],
      additional_relation_keys: []|
  include_context "common action context"
  subject { post :create, params: { resource: params } }

  let(:params) do
    success_params.transform_values do |val|
      val.class.in?([Date, DateTime]) ? val.iso8601 : val
    end
  end
  let(:success_params) { {} }
  let(:success_expected_attrs) { success_params }
  let(:failure_params) { success_params.transform_values { |_val| nil } }
  let(:permission_action) { "create" }

  include_examples "when not authenticated"
  include_examples "when not authorized"
  include_examples "action permission"

  context "when authenticated and authorized", with_auth_stub: true do
    it do
      expect { subject }.to change { resource_class.count }
                        .from(0).to(1)
      resource = resource_class.last
      success_expected_attrs.each do |k, v|
        expect(resource.public_send(k)).to eq(v)
      end
      expect(response.status).to eq(201)
      expect(response.parsed_body).to eq("id" => resource.id)
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

          it_behaves_like "validation failed on create action"
        end
      end
    else
      context "if validation failed" do
        let(:params) { failure_params }
        let(:expected_errors) do
          failure_params.except(*(optional_params || [])).map do |k, _v|
            { "key" => "resource.#{k}", "value" => "must be filled" }
          end
        end

        it_behaves_like "validation failed on create action"
      end
    end

    context "if relations are not found" do
      let(:relation_keys) do
        success_params.keys.select { |k| k.end_with?("_id") } +
          (additional_relation_keys || [])
      end
      let(:params) do
        success_params.to_h { |k, v| [k, k.in?(relation_keys) ? 0 : v] }
      end
      let(:expected_errors) do
        relation_keys.map do |k|
          { "key" => "resource.#{k}", "value" => "must exist" }
        end
      end

      it_behaves_like("validation failed on create action",
                      skip_without_expected_errors: true)
    end
  end
end

RSpec.shared_examples_for(
  "validation failed on create action"
) do |skip_without_expected_errors: false|
  it do
    next if skip_without_expected_errors && expected_errors.blank?

    expect { subject }
      .not_to change { resource_class.count }.from(0)
    expect(response.status).to eq(422)
    expect(response.parsed_body["errors"]).to match_array(expected_errors)
  end
end
