class SearchesController < ApplicationController
  before_action :set_search_item

  def search
    # calls search.html.erb by default   
  end

  private
  def set_search_item
    @search_item = params[:search].upcase
  end

end