require 'rails_helper'

shared_examples_for Commented do
  describe 'POST #create' do
    context 'User' do
      before { login(user) }

      it 'create comment' do
        expect { post :create_comment, params: { id: commenteble, comment: attributes_for(:comment), format: :js } }.to change(commenteble.comments, :count).by(1)
      end
    end

    context 'Author' do
      before { login(author) }

      it 'create comment' do
        expect { post :create_comment, params: { id: commenteble, comment: attributes_for(:comment), format: :js } }.to change(commenteble.comments, :count).by(1)
      end
    end

    context 'Unauthenticated user' do
      it 'create comment' do
        expect { post :create_comment, params: { id: commenteble, comment: attributes_for(:comment), format: :js } }.to_not change(commenteble.comments, :count)
      end
    end
  end
end
