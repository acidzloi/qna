class LinksController < ApplicationController
  before_action :link, only: :destroy
  authorize_resource

  def destroy
    @link.destroy
  end

  private

  def link
    @link = Link.find(params[:id])
  end
end
