require 'rails_helper'

shared_examples_for Voted do
  describe 'POST #create' do
    context 'User' do
      before { login(user) }

      it 'vote up' do
        expect { post :vote_up, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(1)
      end

      it 'vote down' do
        expect { post :vote_down, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(1)
      end

      it 'recall' do
        expect { post :vote_down, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(1)
        expect { post :recall, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(-1)
      end
    end

    context 'Author' do
      before { login(author) }

      it 'vote up' do
        expect { post :vote_up, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
      end

      it 'vote down' do
        expect { post :vote_down, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
      end

      it 'recall' do
        expect { post :vote_down, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
        expect { post :recall, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
      end
    end

    context 'Unauthenticated user' do
      it 'vote up' do
        expect { post :vote_up, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
      end

      it 'vote down' do
        expect { post :vote_down, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
      end

      it 'recall' do
        expect { post :vote_down, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
        expect { post :recall, params: { id: voteble, format: :json } }.to change(voteble.votes, :count).by(0)
      end
    end
  end
end
