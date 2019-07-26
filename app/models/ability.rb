class Ability
  include CanCan::Ability

  def initialize(user = nil)
    user ||= User.new
    # cannot [:create, :destroy, :update], Unit, unit_type: ['delivery', 'postbuy']
    if user.superadmin?
        can :manage, User
        can :manage, Unit
        can :manage, UserLog
        can :manage, Role
        can :role, :unitadmin
        can :role, :user
        can :manage, UpDownload

        # cannot :role, :superadmin
        cannot [:role, :create, :destroy, :update], User, role: 'superadmin'
        can :update, User, id: user.id
        can :manage, ImportFile
        can :manage, Supplier
        can :manage, Commodity

        can :manage, Order
        can :manage, OrderDetail
        
    elsif user.unitadmin?
    #can :manage, :all
        

        # can :manage, Unit, id: user.unit_id
        can :manage, Unit, unit_type: 'branch'
        can :read, Unit, unit_type: ['delivery', 'postbuy']
        can :user, Unit, unit_type: ['delivery', 'postbuy']

        can :read, UserLog, user: {unit_id: user.unit_id}


        # can :manage, User, unit_id: user.unit_id
        can :manage, User, role: 'user'

        # can :manage, Role
        # cannot :role, User, role: 'superadmin'
        # can :role, :unitadmin
        # can :role, :user
        
        # cannot :role, User, role: 'unitadmin'
        cannot [:create, :destroy, :update], User, role: ['unitadmin', 'superadmin']
        
        can :update, User, id: user.id
        can :manage, UpDownload
        # can :manage,BusinessRelationship
        can :manage, ImportFile
        can :manage, Supplier
        can :manage, Commodity
        can [:read, :update, :look], Order
        can [:read, :update, :cancel, :edit, :look, :read_log], OrderDetail
    elsif user.user?
        can :update, User, id: user.id
        can :read, UserLog, user: {id: user.id}

        can :read, Unit, id: user.unit_id
        can [:read, :up_download_export], UpDownload
        can [:read, :download], ImportFile

        if user.unit.unit_type.eql?"branch"
            can [:read, :fresh, :create, :to_check, :update, :destroy, :new, :commodity_choose, :receiving, :pending], Order, user_id: user.id
            can [:read, :look], Order, unit_id: user.unit_id
            can [:read, :look, :read_log], OrderDetail, order: {unit_id: user.unit_id}
            can [:read, :update, :destroy, :new, :create, :receiving, :confirm, :pending, :cancel, :edit, :to_check], OrderDetail, order: {user_id: user.id}
            # can :manage, OrderDetail
            can :read, Commodity
            can :read, Supplier
            can :cover_show, Commodity
            can :contracts_show, Supplier
        end
        if user.unit.eql? Unit::DELIVERY
            can :manage, Supplier
            can [:read, :checking, :declined, :look], Order
            can [:read, :checking, :to_recheck, :check_decline, :declined, :look, :read_log], OrderDetail
            can :read, Commodity
            can :cover_show, Commodity
        end
        if user.unit.eql? Unit::POSTBUY
            can :manage, Commodity
            can :read, Supplier
            can :contracts_show, Supplier
            can [:read, :rechecking, :look], Order
            can [:read, :rechecking, :place, :recheck_decline, :look, :read_log], OrderDetail
        end
    else
        cannot :manage, :all
        #can :update, User, id: user.id
        cannot :read, User
        
    end
    

    end
end




# if user.admin?(storage)


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
# https://github.com/ryanb/cancan/wiki/Defining-Abilities
