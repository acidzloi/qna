require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_one(:badge).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many_attached(:files) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it_behaves_like Voteble
  it_behaves_like Commenteble
end
