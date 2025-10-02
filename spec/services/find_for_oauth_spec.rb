require 'rails_helper'

RSpec.describe Services::FindForOauth do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'githab', uid: '123') }

  describe '.call' do
    describe 'user already exist' do
      subject { Services::FindForOauth.new(auth, user.email) }

      context 'user exist by email' do
        it 'returns user by email' do
          expect(subject.call).to eq user
        end
      end

      context 'user has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'githab', uid: '123')

          expect(subject.call).to eq user
        end
      end

      context 'user has not authorization' do
        context 'user already exists' do
          it 'does not create new user' do
            expect { subject.call }.to_not change(User, :count)
          end

          it 'create authorization for user' do
            expect { subject.call }.to change(user.authorizations, :count).by(1)
          end

          it 'returns the user' do
            expect(subject.call).to eq user
          end
        end
      end
    end

    describe 'user does not exist' do
      subject { Services::FindForOauth.new(auth, 'new_user@test.local') }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'create authorization for new user' do
        expect { subject.call }.to change(Authorization, :count).by(1)
        expect(subject.call.email).to eq 'new_user@test.local'
      end

      it 'returns new user' do
        expect(subject.call).to eq User.find_by(email: 'new_user@test.local')
      end
    end
  end
end
