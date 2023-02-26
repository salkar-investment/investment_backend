# frozen_string_literal: true

RSpec.shared_examples_for(
  "index action"
) do |filter_params: [], filter_params_for_date: [], pagination: true|
  include_context "common action context"
  subject { get :index, params: }

  let(:params) { {} }
  let(:expected_result) { [serialized_resource] }
  let(:permission_action) { "index" }
  let!(:resource) { create(factory_name) }

  include_examples "when not authenticated"
  include_examples "when not authorized"
  include_examples "action permission"

  context "when authenticated and authorized", with_auth_stub: true do
    it do
      subject
      expect(response.status).to eq(200)
      expect(response.parsed_body["data"]).to match_array(expected_result)
      expect(response.parsed_body["meta"])
        .to eq("current_page" => 1, "total_pages" => 1)
    end

    if pagination
      context "pagination" do
        it_behaves_like "index action param" do
          let(:param_name) { :page }
          let(:non_blank_param_value) { 1 }
          let(:blank_param_value) { 2 }
        end
      end
    end

    filter_params.each do |filter_param|
      context "#{filter_param} filter" do
        it_behaves_like "index action param" do
          let(:param_name) { filter_param }
          let(:non_blank_param_value) do
            resource.public_send(filter_param.to_s.sub(/_eq$/, ""))
          end
        end
      end
    end

    filter_params_for_date.each do |date_field|
      context "#{date_field}_eq" do
        it_behaves_like "index action param" do
          let(:param_name) { "#{date_field}_eq" }
          let(:non_blank_param_value) do
            resource.public_send(date_field).iso8601
          end
          let(:blank_param_value) do
            (resource.public_send(date_field) + 1.day).iso8601
          end
        end
      end

      context "#{date_field}_lt" do
        it_behaves_like "index action param" do
          let(:param_name) { "#{date_field}_lt" }
          let(:blank_param_value) do
            resource.public_send(date_field).iso8601
          end
          let(:non_blank_param_value) do
            (resource.public_send(date_field) + 1.day).iso8601
          end
        end
      end

      context "#{date_field}_lteq" do
        it_behaves_like "index action param" do
          let(:param_name) { "#{date_field}_lteq" }
          let(:blank_param_value) do
            (resource.public_send(date_field) - 1.day).iso8601
          end
          let(:non_blank_param_value) do
            resource.public_send(date_field).iso8601
          end
        end
      end

      context "#{date_field}_gt" do
        it_behaves_like "index action param" do
          let(:param_name) { "#{date_field}_gt" }
          let(:blank_param_value) do
            resource.public_send(date_field).iso8601
          end
          let(:non_blank_param_value) do
            (resource.public_send(date_field) - 1.day).iso8601
          end
        end
      end

      context "#{date_field}_gteq" do
        it_behaves_like "index action param" do
          let(:param_name) { "#{date_field}_gteq" }
          let(:blank_param_value) do
            (resource.public_send(date_field) + 1.day).iso8601
          end
          let(:non_blank_param_value) do
            resource.public_send(date_field).iso8601
          end
        end
      end
    end
  end
end

RSpec.shared_examples_for "index action param" do
  include_context "common action context"
  subject { get :index, params: }

  let(:permission_action) { "index" }
  let(:blank_param_value) { 0 }
  let(:non_blank_result) { { "id" => resource.id } }

  context "when authenticated and authorized", with_auth_stub: true do
    let(:params) { { param_name => non_blank_param_value } }

    it do
      subject
      expect(response.status).to eq(200)
      expect(response.parsed_body["data"])
        .to match_array(hash_including(non_blank_result))
    end

    context "when no match found" do
      let(:params) { { param_name => blank_param_value } }

      it do
        subject
        expect(response.status).to eq(200)
        expect(response.parsed_body["data"]).to eq([])
      end
    end
  end
end
