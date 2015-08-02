class PrestamoController < ApplicationController
	protect_from_forgery with: :null_session
  before_action :check_auth
  respond_to :json
   rescue_from(ActiveRecord::RecordInvalid) do |invalid|
   response = {status: 'error', fields: invalid.record.errors}
   render json: response, status: :unprocesaable_entity
   end
   rescue_from(ActiveRecord::RecordNotFound) do |invalid|
   response = {status: 'error', fields: 'registro no encontrado'}
   render json: response, status: :unprocesaable_entity
   end
   #require 'gcm'
   require 'twilio-ruby'
  

  def check_auth
    authenticate_or_request_with_http_basic do |username,password|
      resource = User.find_by_email(username) 
      if resource != nil
        if resource.valid_password?(password)
        sign_in :user, resource
        $identi = resource
        else
          render :json => {status: 0}
        end
      else
        render :json => {status: 2}
      end
      
      end
  end

  # def hashCode(code)
  # 	a = code.split("")
  # 	array = Array.new
  # 	abc = ('a'..'z').to_a 
  # 	a.each do |le|
  # 		if le.to_i == 0
  # 			if le == 'z'
  # 				pos = abc.index(le)
	 #  			nl = abc[pos-1]
	 #  			array.push(nl)
	 #  		else
	 #  			pos = abc.index(le)
	 #  			nl = abc[pos+1]
	 #  			array.push(nl)
  # 			end
  # 		else 
  # 			if le.to_i == 9
  # 				num = le.to_i-1
  # 				array.push(num)
  # 			else
  # 				num = le.to_i+1
  # 				array.push(num)
  # 			end
  # 		end
  # 	puts array.length
  # 	end
  	
  end

	def newCode
		account_sid = 'AC4be349f804e4ae042e9fc9d5c4a3ae98'
		auth_token = 'd50daebd8632358fd0b52be9fea16f14'
		@client = Twilio::REST::Client.new account_sid, auth_token
		Twilio.configure do |config|
		  config.account_sid = account_sid
		  config.auth_token = auth_token
		end

		@client = Twilio::REST::Client.new

		# response = Twilio::TwiML::Response.new do |r|
		#   r.Say 'hello there', voice: 'alice'
		#   r.Dial callerId: '+14159992222' do |d|
		#     d.Client 'jenny'
		#   end
		# end
		@code = Code.new code_params
		@code.user_id = $identi
		@code.code = SecureRandom.hex(2)
		if @code.save!
			#hashCode(@code.code)
			# registration_ids= Array.new
			# registration_ids.push(@user.registerid) 	
			# gcm = GCM.new("AIzaSyC1HcimOsaWkpZPg0y9eWkg3a-TD2NmR_E")
			# options = {data: {mensaje: "Nuevo Pago", subtitulo: "Compra por : " + @record.cantidad.to_s}, saldo:'tu saldo es de: '+@record.saldo.to_s}
			# response = gcm.send(registration_ids, options)
			render json: {status:0, code:@code.code}
			@client.messages.create(
			  from: '+18482202575',
			  to: '+52 0445585491123',
			  body: 'Hola, tu codigo es: '+ @code.code
			  )
		else
			render json: {status:1}
		end
	end


	protected

	def code_params
		params.permit(:cantidad)
	end
end
