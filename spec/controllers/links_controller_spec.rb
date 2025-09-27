require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    before { login(author) }

    context 'author' do
      it 'delete question link' do
        expect do
          delete :destroy, params: { id: question_link }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 're-render question show' do
        delete :destroy, params: { id: question_link }, format: :js
        expect(response).to render_template :destroy
      end

      it 'delete answer link' do
        expect do
          delete :destroy, params: { id: answer_link }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 're-render answer show' do
        delete :destroy, params: { id: answer_link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user' do
      before { login(user) }

      it 'can not delete the question link' do
        expect { delete :destroy, params: { id: question_link }, format: :js }.to_not change(Link, :count)
      end

      it 'can not delete the answer link' do
        expect { delete :destroy, params: { id: answer_link }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
