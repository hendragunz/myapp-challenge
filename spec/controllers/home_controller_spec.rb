require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }

  describe "GET /show" do
    context 'with no login' do
      it 'should redirected to login page' do
        get :show
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    context 'with logged in' do
      before {
        sign_in(user)
      }

      it 'should render successfully' do
        get :show
        expect(response).to have_http_status(:ok)
        expect(response).to render_template("show")
      end
    end
  end
end
