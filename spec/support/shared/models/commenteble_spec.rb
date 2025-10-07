require 'rails_helper'

shared_examples_for Commenteble do
  describe 'Associations' do
    it { should have_many(:comments).dependent(:destroy) }
  end
end
