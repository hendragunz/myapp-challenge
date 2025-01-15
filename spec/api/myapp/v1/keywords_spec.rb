require 'rails_helper'

describe Myapp::V1::Keywords, type: :request do
  let!(:user) { create(:user, email: 'user-api@example.com', password: '123123123', password_confirmation: '123123123') }

  # to generate the authentication token
  # must hit this method once
  #
  before {
    user.reset_authentication_token!
  }

  let(:headers) {
    {
      'access-token' => user.authentication_token
    }
  }

  describe "GET /api/v1/keywords" do
    let!(:keywords) { create_list(:keyword, 3, user: user) }

    it 'should render keywords data' do
      get "/api/v1/keywords", headers: headers, as: :json
      expect(parsed_json['keywords'].size).to eq(3)
      expect(response.code).to eq("200")
    end
  end

  describe "GET /api/v1/keywords/:id" do
    let(:keyword)       { create(:keyword, user: user) }
    let(:other_keyword) { create(:keyword) }

    it 'should render keyword detail' do
      get "/api/v1/keywords/#{keyword.id}", headers: headers, as: :json
      expect(parsed_json['keyword']['name']).to eq(keyword.name)
      expect(response.code).to eq("200")
    end

    it 'should render error not found' do
      get "/api/v1/keywords/#{other_keyword.id}", headers: headers, as: :json
      expect(parsed_json['error']).to eq('Data not found')
      expect(response.code).to eq("404")
    end
  end


  describe "DELETE /api/v1/keywords/:id" do
    let!(:keyword)       { create(:keyword, user: user) }
    let!(:other_keyword) { create(:keyword) }

    it 'should render keyword detail' do
      expect {
        delete "/api/v1/keywords/#{keyword.id}", headers: headers, as: :json
      }.to change { user.reload.keywords.length }.by(-1)

      expect(parsed_json['keyword']['name']).to eq(keyword.name)
      expect(response.code).to eq("200")
    end

    it 'should render error not found' do
      delete "/api/v1/keywords/#{other_keyword.id}", headers: headers, as: :json
      expect(parsed_json['error']).to eq('Data not found')
      expect(response.code).to eq("404")
    end
  end


  describe "POST /api/v1/keywords" do
    let(:file)      { fixture_file_upload("example_keywords.csv", "text/csv") }   # contain 4 rows
    let(:bad_file)  { fixture_file_upload("sample.pdf", "application/pdf") }      # PDF file

    let(:api_params) {
      {
        keyword: {
          file: file
        }
      }
    }

    context 'with valid CSV file' do
      it 'should create keywords properly' do
        expect(user.keywords.count).to eq(0)

        expect {
          post "/api/v1/keywords", headers: headers, params: api_params
        }.to change { user.keywords.count }.by(4)
      end
    end

    context 'with bad CSV file' do
      let(:api_params) {
        {
          keyword: {
            file: bad_file
          }
        }
      }

      it 'should handle gracefully for bad file' do
        expect {
          post "/api/v1/keywords", headers: headers, params: api_params
        }.to change { user.keywords.count }.by(0)

        expect(parsed_json['error']).to eq('Uploaded file must by CSV')
        expect(response.code).to eq('400')
      end
    end

    context 'with empty file' do
      let(:api_params) {
        {
          keyword: {
            file: nil
          }
        }
      }

      it 'should handle gracefully for empty file' do
        expect {
          post "/api/v1/keywords", headers: headers, params: api_params
        }.to change { user.keywords.count }.by(0)

        expect(parsed_json['error']).to eq('keyword[file] is empty')
        expect(response.code).to eq('400')
      end
    end
  end


  # Specific test if hit API with no credential / access-token
  #
  context 'without login' do
    describe "GET /api/v1/keywords" do
      it 'should render message not authorized' do
        get "/api/v1/keywords", as: :json
        expect(parsed_json['error']).to eq('401 Unauthorized')
        expect(response.code).to eq("401")
      end
    end
  end
end
