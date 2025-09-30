require 'rails_helper'

shared_examples_for Voteble do
  let(:model) { described_class }
  let(:author) { create(:user) }
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }

  let(:voteble) do
    voted(model, author)
  end

  describe 'Associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#vote_up' do
    it 'votes up' do
      voteble.vote_up(first_user)

      expect(voteble.total_votes).to eq 1
    end

    it 'vote up once' do
      voteble.vote_up(first_user)
      voteble.vote_up(first_user)

      expect(voteble.total_votes).to eq 1
    end
  end

  describe '#vote_down' do
    it 'votes down' do
      voteble.vote_down(first_user)

      expect(voteble.total_votes).to eq (-1)
    end

    it 'vote down once' do
      voteble.vote_down(first_user)
      voteble.vote_down(first_user)

      expect(voteble.total_votes).to eq (-1)
    end
  end

  describe '#total_vote' do
    let!(:first_vote) { create(:vote, user: first_user, voteble: voteble, vote: 1) }
    let!(:second_vote) { create(:vote, user: second_user, voteble: voteble, vote: 1) }

    it 'total vote sum' do
      expect(voteble.total_votes).to eq 2
    end
  end

  describe '#recall' do
    it 'recall vote' do
      voteble.vote_up(first_user)
      voteble.recall(first_user)

      expect(voteble.total_votes).to eq 0
    end
  end

  describe 'Author' do
    it 'can not vote' do
      voteble.vote_up(author)

      expect(voteble.total_votes).to eq 0
    end
  end
end
