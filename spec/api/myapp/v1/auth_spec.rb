require 'rails_helper'

describe Myapp::V1::Auth, type: :request do
  let!(:user) { create(:user, email: 'user-api@example.com', password: '123123123', password_confirmation: '123123123') }

  describe "POST /api/v1/auth" do
    context "with valid email + password" do
      let(:api_params) {
        {
          user: {
            email: 'user-api@example.com',
            password: '123123123'
          }
        }
      }

      it 'should return access token data' do
        post "/api/v1/auth", params: api_params, as: :json
        expect(parsed_json['email']).to eq(user.email)
        expect(parsed_json['access_token']).to be_present
      end
    end

    context "with invalid email or password" do
      let(:api_params) {
        {
          user: {
            email: 'user-bad@example.com',
            password: '123123123'
          }
        }
      }

      it 'should return error message' do
        post "/api/v1/auth", params: api_params, as: :json
        expect(parsed_json['error']).to eq('User with given email address is not found')
      end
    end
  end
end
