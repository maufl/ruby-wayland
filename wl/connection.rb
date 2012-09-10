require 'socket'

module WL
	class Connection

		def initialize(address)
			@address = address
			@socket = UNIXSocket.new(@address)
			@objects = []
		end

		def start_event_loop
			while header = @socket.read(8)
				header_content = Message.unpack_header(header)
				body = @socket.read(header_content[:size]-8)
				if @objects.empty?
					message = Interface::WL_DISPLAY.unpack(1, header+body)
					display = @objects[header_content[:sender]] = Interface::WL_DISPLAY.new(header_content[:sender])
					display.on_global do |args|
						if Interface.constants.include?(args["interface"].upcase.intern)
							puts "Adding new object of interface #{args["interface"]} with id #{args["name"]}"
							obj = Interface.const_get(args["interface"].upcase.intern).new(args["name"])
							@objects[args["name"]] = obj
						else
							puts "I don't know the interface #{args["interface"]}"
						end
					end
				elsif sender = @objects[header_content[:sender]]
					message = sender.class.unpack(header_content[:code], header+body)
					sender.fire(header_content[:code], message.body)
				end
			end
		end

		def objects
			@objects
		end
	end

end
