class Ability
  include CanCan::Ability

  def initialize(user)


    user ||= User.new # guest user (not logged in)
    if user.roles_mask==0

      #control if an user can follow a store or he has already followed it.
      can :follow, Store do |store|
         !FollowStore.where(store_id: store.id, user_id: user.id).exists?
      end
      #control if an user wants to unfollow, he has to be a foolower
      can :unfollow, Store do |store|
         FollowStore.where(store_id: store.id, user_id: user.id).exists?
      end

      can :follow, User do |client|
        !FollowerUser.where(follower_id: user.id,followed_id:client.id).exists? && client.id != user.id
      end

      can :unfollow, User do |client|
        FollowerUser.where(follower_id: user.id,followed_id:client.id).exists? && client.id != user.id
      end

      #can menage  it self
      can :manage, User do |client|
       client.id == user.id
      end
      #stores

      #comment
      can :create , Comment do |comment|
         !Work.where(store_id: comment.store_id, user_id: user.id).exists?
      end

      can :update, Comment do |comment|
        comment.user_id==user.id
      end

    elsif user.roles_mask==1 || user.roles_mask==2
      #respond
      can :create, Respond do |respond|
          Work.where(store_id: respond.store_id,user_id: user.id).exists?
      end

      can :updare, Respond do |respond|
          Work.where(store_id: respond.store_id,user_id: user.id).exists?
      end

    else
      can :read, :all
    end




    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
