module Admin
  class Ability
    include CanCan::Ability

    def initialize(user)
      return unless user.admin?

      can :read, Order
      can :read, Trade
      can :read, Proof
      can :update, Proof
      can :manage, Document
      can :manage, Member
      can :manage, Ticket
      can :manage, IdDocument
      can :manage, TwoFactor

      can :menu, Deposit
      can :manage, ::Deposits::Bank
      can :manage, ::Deposits::Satoshi
      can :manage, ::Deposits::Blackcoin
      can :manage, ::Deposits::Litecoin
      can :manage, ::Deposits::Peercoin
      can :manage, ::Deposits::Realpointcoin
      can :manage, ::Deposits::Tritiumcoin
      can :manage, ::Deposits::Stellarcoin

      can :manage, ::Deposits::Litecoin

      can :menu, Withdraw
      can :manage, ::Withdraws::Bank
      can :manage, ::Withdraws::Satoshi
      can :manage, ::Withdraws::Blackcoin
      can :manage, ::Withdraws::Litecoin
      can :manage, ::Withdraws::Peercoin
      can :manage, ::Withdraws::Realpointcoin
      can :manage, ::Withdraws::Tritiumcoin
      can :manage, ::Withdraws::Litecoin
      can :manage, ::Withdraws::Stellarcoin

    end
  end
end