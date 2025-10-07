require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do
    context 'for authenticated user' do
      before { login(user) }

      it 'subscription create' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(1)
      end

      it 'redirect to subscription create view'  do
        post :create, params: { question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'for unauthenticated user' do
      it 'subscription do not create' do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(question.subscriptions, :count)
      end

      it 'returns 401 status' do
        post :create, params: { question_id: question }, format: :js

        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      before do
        login(user)
        post :create, params: { question_id: question }, format: :js
      end

      it 'subscription delete' do
        expect { delete :destroy, params: { id: question.subscriptions.find_by(user: user) }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it 'redirect to subscription destroy view'  do
        delete :destroy, params: { id: question.subscriptions.find_by(user: user) }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'for unauthenticated user' do
      before do
        login(user)
        post :create, params: { question_id: question }, format: :js
        logout(user)
      end

      it 'subscription do not delete' do
        expect { delete :destroy, params: { id: user.subscriptions.first }, format: :js }.to_not change(question.subscriptions, :count)
      end

      it 'returns 401 status' do
        delete :destroy, params: { id: user.subscriptions.first }, format: :js

        expect(response.status).to eq 401
      end
    end
  end
end
