class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if current_user.author?(attachment.record)
      attachment.purge
    else
      redirect_to attachment.record
    end
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
