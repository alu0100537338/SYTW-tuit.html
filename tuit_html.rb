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
	   
	   #Si no esta vacio , no es un espacio y el usuario existe en Twitter el nombre es el introducido
	    #@name = (req["firstname"] && req["firstname"] != '' && Twitter.user?(req["firstname"]) == true ) ? req["firstname"] : ''

		#@number = (req["n"] && req["n"].to_i>1 ) ? req["n"].to_i : 1
		#puts "#{req["n"]}"
		
		#Si el nombre existe buscamos sus últimos Tweets
		#if @nombre == req["firstname"]
			@nombre = req["usuario"]
			@numero = req ["numero"] 
			puts "#{@tuits}"
			ultimos = Twitter.user_timeline(@nombre,{:count=>@numero.to_i})
			@tuits =(@tuits && @tuits != '') ? ultimos.map{ |i| i.text} : ''				
		#end

		#Invoca a erb
		Rack::Response.new(erb('tuit.html.erb'))
	end

end

if $0 == __FILE__
	Rack::Server.start( 
		:app => Twitts.new,
	    	:Port => 9292,
	    	:server => 'thin'
  	)
end
