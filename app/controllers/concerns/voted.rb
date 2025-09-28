module Voted
  extend ActiveSupport::Concern

  included do
    before_action :voteble, only: %i[vote_up vote_down recall]
  end

  def vote_up
    unless current_user.author?(@voteble)
      @voteble.vote_up(current_user)
      render_json
    end
  end

  def vote_down
    unless current_user.author?(@voteble)
      @voteble.vote_down(current_user)
      render_json
    end
  end

  def recall
    unless current_user.author?(@voteble)
      @voteble.recall(current_user)
      render_json
    end
  end

  private

  def voteble
    @voteble = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def render_json
    render json: { resource_class: @voteble.class.to_s, id: @voteble.id, votes: @voteble.total_votes }
  end
end
