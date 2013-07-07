class PayementController < ApplicationController

	def new
		@payement = Payement.new  
	end

end