class LinksController < ApplicationController
  def destroy
    if current_user.author?(link.linkable)
      link.destroy
    else
      redirect_to link.linkable
    end
  end

  private

  def link
    @link = Link.find(params[:id])
  end
end
