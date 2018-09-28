module Admin
  module Withdraws
    class StellarcoinsController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Stellarcoin'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_stellarcoins = @stellarcoins.with_aasm_state(:accepted).order("id DESC")
        @all_stellarcoins = @stellarcoins.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @stellarcoin.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @stellarcoin.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
