require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Is the user the author?' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }

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
end
