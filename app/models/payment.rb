class Payment
  include Mongoid::Document

  field :date, type: Date
  field :amount, type: Float
  field :mode, type: String
  field :check_reference, type: String
  field :transfer_reference, type: String

  validates :mode, inclusion: { in: ["Bank Check", "Cash", "Transfer"] } 
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
