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
					message = Message.build(header+body, Interface::WL_DISPLAY.sig(1))
					puts message.to_str
					puts
				end
			end
		end
	end

end
