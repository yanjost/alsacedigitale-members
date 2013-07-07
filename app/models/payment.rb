class Payment
  include Mongoid::Document

  field :date, type: Date
  field :amount, type: Float
  field :mode, type: String
  field :check_reference, type: String
  field :transfer_reference, type: String

  validates :mode, inclusion: { in: ["Bank Check", "Cash", "Transfer", "Paypal"] } 
  validates_with CheckPaymentValidator
  validates_with TransferPaymentValidator

  class CheckPaymentValidator < ActiveModel::Validator
    def validate(record)
      if record.mode == "Bank Check" && (check_reference == nil || check_reference == "")
        record.errors[:base] << "Payment by bank check must have a reference"
      end
    end
  end
  class TransferPaymentValidator < ActiveModel::Validator
    def validate(record)
      if record.mode == "Transfer" && (transfer_reference == nil || transfer_reference == "")
        record.errors[:base] << "Payment by transfer must have a reference"
      end
    end
  end

end

##Paypal

def self.conf
  @@gateway_conf ||= YAML.load_file(Rails.root.join('config/gateway.yml').to_s)[Rails.env]
end

def setup_payement(options)
  gateway.setup_payement(amount * 100, options)
end

def redirect_url(token)
  gateway.redirect_url(token)
end

def purchase(options={}) 
    self.status = PROCESSING  
    #:ip       => request.remote_ip,
    #:payer_id => params[:payer_id],
    #:token    => params[:token]
    response = gateway.purchase(amt, options)      
    if response.success?       
      self.transaction_num = response.params['transaction_id']       
      self.status = SUCCESS     
    else       
      self.status = FAILED     
    end     
    return self   
  rescue Exception => e     
    self.status = FAILED     
    return self   
  end

private   
def gateway 
  ActiveMerchant::Billing::Base.mode = auth['mode'].to_sym 
  ActiveMerchant::Billing::PaypalExpressGateway.new(
    :login => auth['login'], :password => auth['password'],
    :signature => auth['signature']) 
end

  def auth 
    self.class.conf 
  end
end   
