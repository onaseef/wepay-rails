class Wepay::IpnController < Wepay::ApplicationController
  def create
    conds = {
      :security_token  => params[:security_token],
      :checkout_id     => params[:checkout_id],
      :preapproval_id  => params[:preapproval_id],
    }.delete_if {|k,v| v.nil?}

    record = WepayCheckoutRecord.where(conds).first

    if record.present?
      wepay_gateway = WepayRails::Payments::Gateway.new
      checkout = wepay_gateway.lookup_checkout(record.checkout_id)
      checkout.delete_if {|k,v| !record.attributes.include? k}
      record.update_attributes(checkout)
      render :text => "ok"
    else
      raise StandardError.new("Wepay IPN: No record found for checkout_id #{params[:checkout_id]} and security_token #{params[:security_token]}")
    end

  end
end