class AttachmentsController < ApplicationController
  before_action :attachment, only: :destroy
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment.purge
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
