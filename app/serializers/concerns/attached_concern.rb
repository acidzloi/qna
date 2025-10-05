module AttachedConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    has_many :files
  end

  def files
    object.files.map do |file|
      rails_blob_path(file, only_path: true)
    end
  end
end
