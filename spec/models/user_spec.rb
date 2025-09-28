require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:badge) { create(:badge, question: question) }
  let(:answer) { create(:answer, question: question, user: author) }
  let!(:vote) { create(:vote, user: user, voteble: question) }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Is the user the author?' do
    it 'Valid question author' do
      expect(author.author?(question)).to be true
    end

    it 'Invalid question author' do
      expect(user.author?(answer)).to be false
    end

    it 'Valid answer author' do
      expect(author.author?(answer)).to be true
    end

    it 'Invalid answer author' do
      expect(user.author?(question)).to be false
    end
  end

    describe '#add_badge!' do
    subject { user.add_badge!(badge) }

    it 'adds badge to user' do
      expect { subject }.to change {  user.badges.count }.from(0).to(1)
    end
  end

    describe '#voted?' do
    it 'user voted?' do
      expect(user.voted?(question)).to be true
    end
  end
end
