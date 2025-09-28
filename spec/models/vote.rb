require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:voteble) }
  it { should belong_to(:user) }

  it { should validate_presence_of :vote }
  it { should validate_inclusion_of(:vote).in_range(-1..1) }
end