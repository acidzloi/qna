class SearchController < ApplicationController
  skip_authorization_check only: :search

  def search
    @search_results = Services::SearchService.call(params[:search_string], params[:search_area])
  end
end
