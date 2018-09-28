module Private::Withdraws
  class StellarcoinsController < ::Private::Withdraws::BaseController
    include ::Withdraws::Withdrawable
  end
end
