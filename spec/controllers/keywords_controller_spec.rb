require 'rails_helper'

RSpec.describe KeywordsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before {
    sign_in(user)
  }


  describe "GET /index" do
    context 'with no keywords' do
      it 'should render without any keywords data' do
        get :index
        expect(assigns(:keywords)).to match_array([])
      end
    end

    context 'with keywords' do
      let!(:keywords) { create_list(:keyword, 5, user: user) }
      let!(:other_user_keywords) { create_list(:keyword, 3, user: other_user) }

      it 'should render without any keywords data' do
        get :index
        expect(assigns(:keywords)).to match_array(keywords)
      end
    end

    context 'with some existing data' do
      let!(:keyword1) { create(:keyword, user: user, name: "The favorite beach in Thailand for tourist") }
      let!(:keyword2) { create(:keyword, user: user, name: "The favorite hotels in Bangkok for budget traveller") }
      let!(:keyword3) { create(:keyword, user: user, name: "The icon of Bangkok Thailand") }

      it 'sould return all without search' do
        get :index
        expect(assigns(:keywords)).to match_array([keyword1, keyword2, keyword3])
      end

      it 'sould return keywords with given search properly' do
        get :index, params: { search: { terms: 'bangkok' } }
        expect(assigns(:keywords)).to include(keyword2, keyword3)
        expect(assigns(:keywords)).to_not  include(keyword1)
      end
    end
  end


  describe "GET /show" do
    let(:keyword) { create(:keyword, user: user) }
    let(:other_keyword) { create(:keyword, user: other_user) }

    context "with valid keyword ID" do
      it 'should render show page' do
        get :show, params: {id: keyword.id}
        expect(assigns(:keyword)).to eq(keyword)
        expect(response).to render_template("show")
      end
    end

    context "with invalid keyword ID" do
      it 'should redirect to index with error message' do
        get :show, params: {id: other_keyword.id}
        expect(response).to redirect_to("/keywords")
        expect(flash[:error]).to be_present
      end
    end
  end


  describe "DELETE /destroy" do
    let!(:keyword) { create(:keyword, user: user) }
    let!(:other_keyword) { create(:keyword, user: other_user) }

    context "with valid keyword ID" do
      it 'should redirect to index page' do
        expect {
          delete :destroy, params: {id: keyword.id}
        }.to change { user.keywords.count }.by(-1)

        expect(response).to redirect_to("/keywords")
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid keyword ID" do
      it 'should redirect to index with error message' do
        expect {
          delete :destroy, params: {id: other_keyword.id}
        }.to change { user.keywords.count }.by(0)

        expect(response).to redirect_to("/keywords")
        expect(flash[:error]).to be_present
      end
    end
  end


  describe "POST /create" do
    let(:file) { fixture_file_upload("example_keywords.csv", "text/csv") }  # contain 4 rows

    context 'with valid file' do
      it 'should upload and create keywords' do
        expect {
          post :create, params: {
            upload_keywords: {
              file: file
            }
          }
        }.to change { user.keywords.count }.by(4)
      end
    end

    context 'with bad file' do
      context 'with empty file' do
        it 'should redirect with error message' do
          expect {
            post :create, params: {
              upload_keywords: {
                file: nil
              }
            }
          }.to change { user.keywords.count }.by(0)

          expect(flash[:error]).to be_present
          expect(response).to redirect_to("/keywords")
        end
      end

      context 'with wrong file type (not CSV)' do
        it 'should redirect with error message' do
          expect {
            post :create, params: {
              upload_keywords: {
                file: fixture_file_upload("sample.pdf", "application/pdf")
              }
            }
          }.to change { user.keywords.count }.by(0)

          expect(flash[:error]).to eq("File type must be CSV")
          expect(response).to redirect_to("/keywords")
        end
      end
    end

  end
end
