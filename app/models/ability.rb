class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [ Question, Answer ]
    can :update, [ Question, Answer ],  user_id: user.id
    can :destroy, [ Question, Answer ], user_id: user.id

    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can [ :vote_up, :vote_down ], [ Question, Answer ]
    cannot [ :vote_up, :vote_down ], [ Question, Answer ], user_id: user.id
    can :recall, [ Question, Answer ] do |resource|
      resource.votes.find_by(user_id: user.id)
    end

    can :create_comment, [ Question, Answer ]

    can :best, Answer, question: { user_id: user.id }

    can :destroy, Link do |resource|
      user.author?(resource.linkable)
    end
  end
end
