class Wepay::CheckoutController < Wepay::ApplicationController
  def index
    conds = {
      :security_token  => params[:security_token],
      :checkout_id     => params[:checkout_id],
      :preapproval_id  => params[:preapproval_id],
    }.delete_if {|k,v| v.nil?}

    record = WepayCheckoutRecord.where(conds).first

    if record.present?
      wepay_gateway = WepayRails::Payments::Gateway.new
      if record.checkout_id.present?
        checkout = wepay_gateway.lookup_checkout(record.checkout_id)
      else
        checkout = wepay_gateway.lookup_preapproval(record.preapproval_id)
      end
      record.update_attributes(checkout)
      redirect_to "#{wepay_gateway.configuration[:after_checkout_redirect_uri]}?checkout_id=#{params[:checkout_id]}"
    else
      raise StandardError.new("Wepay IPN: No record found for checkout_id #{params[:checkout_id]} and security_token #{params[:security_token]}")
    end
  end
end