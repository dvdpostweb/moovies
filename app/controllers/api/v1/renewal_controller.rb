class Api::V1::RenewalController < API::V1::BaseController

    def renew
        render json: setup_orange_subscription_renewal
    end

    private

    def setup_orange_subscription_renewal
        OrangeRenewService.new(
            discount: params[:discount],
            customer: params[:customer]
        ).perform
    end

end
