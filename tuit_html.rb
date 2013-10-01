# -*- coding: utf-8 -*-
require 'twitter'
require './configure'
require 'rack'
require 'pry-debugger'
require 'thin'
require 'erb'

class Twitts

	#Inicializar variables
	def initialize
		@tuits = []
		@nombre = ''
		@numero = 0		
	end

	#Acceso al HTML para mostrar los resultados
	def erb(template)
  		template_file = File.open("tuit.html.erb", 'r')
  		ERB.new(File.read(template_file)).result(binding)
	end
	
	#Método call
	def call env

	    req = Rack::Request.new(env)
	    
	    binding.pry if ARGV[0]
	   
	    @nombre =(req["usuario"] && req["usuario"] != '') ? req["usuario"] : ''

	    @numero =  (req["numero"] && req["numero"].to_i>1 ) ? req["numero"].to_i : 1

	    if @nombre != ''
	    	 puts "Entre"

		 ultimos = Twitter.user_timeline(@nombre,{:count=>@numero.to_i})
		 @tuits =(@tuits && @tuits != '') ? ultimos.map{ |i| i.text} : ''
	    end				

	    Rack::Response.new(erb('tuit.html.erb'))

	end

end

if $0 == __FILE__
	Rack::Server.start( 
		:app => Twitts.new,
	    	:Port => 8000,
	    	:server => 'thin'
  	)
end
