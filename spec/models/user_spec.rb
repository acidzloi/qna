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
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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

    describe '.find_for_ouath' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'githab', uid: '123') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth, user.email).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth, user.email)
    end
  end

  describe '.find_or_create' do
    let!(:user) { create(:user) }

    it 'find need user by email' do
      expect(User.find_or_create(user.email)).to eq user
    end

    it 'creates new user' do
      expect { User.find_or_create('new_user@test.local') }.to change(User, :count).by(1)
    end
  end

  describe '.create_with_password!' do
    it 'creates new user' do
      expect { User.create_with_password!('new_user@test.local') }.to change(User, :count).by(1)
    end

    it 'creates user with email' do
      expect(User.create_with_password!('new_user@test.local')).to eq User.find_by(email: 'new_user@test.local')
    end
  end

  describe '.find_by_auth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'githab', uid: '123') }

    it 'returns the user' do
      user.create_authorization(auth)

      expect(User.find_by_auth(auth)).to eq user
    end
  end

  describe '.create_authorization' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'githab', uid: '123') }

    it 'create new authorization' do
      expect { user.create_authorization(auth) }.to change(Authorization, :count).by(1)
    end
  end

  describe '#subscribe?' do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'when user has subscription' do
      it 'returns true' do
        expect(user.subscribe?(question)).to eq true
      end
    end

    context 'when user has not subscription' do
      it 'returns false' do
        expect(second_user.subscribe?(question)).to eq false
      end
    end
  end  
end
