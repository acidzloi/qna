require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'search in area: All' do
      expect(ThinkingSphinx).to receive(:search).with 'search'
      get :search, params: { search_string: 'search', search_area: 'All' }
    end

    %w[Question Answer Comment User].each do |area|
      it "search in area: #{area}" do
        expect(area.constantize).to receive(:search).with 'test'
        get :search, params: { search_string: 'test', search_area: "#{area}s" }
      end
    end
  end
end
