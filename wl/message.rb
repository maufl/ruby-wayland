module WL

	class Message
		class ParseError < Exception; end

		def self.unpack_header(header)
			raise ParseError.new("The header has not the right size!") unless header.bytesize == 8
			header_copy = header.clone
			sender = pop_uint!(header_copy)
			op_code = pop_short!(header_copy)
			message_size = pop_short!(header_copy)
			raise ParseError.new("Something went wrong while unpacking a header!") unless header_copy.bytesize == 0
			{ :sender => sender, :size => message_size, :code => op_code }
		end

		def self.build(bytes, signature)
			header = unpack_header(bytes.byteslice(0,8))
			body = unpack_body(bytes.byteslice(8,bytes.bytesize-8), signature)
			self.new(header,body)
		end

		def to_str
			out = ""
			out << "=Header=\n"
			out << "Sender: #{@header[:sender]}\n"
			out << "Message length: #{@header[:size]}\n"
			out << "Opcode: #{@header[:code]}\n"
			out << "=Body=\n"
			@body.each do |name, value|
				out << "#{name} - #{value}\n"
			end
			out
		end

		private

		def initialize(header,body)
			@header = header
			@body = body
		end

		def self.unpack_body(bytes, signature)
			fields = {}
			signature.each do |field|
				type = field[0]
				name = field[1]
				fields[name] = case type
							   when :uint
								   pop_uint!(bytes)
							   when :string
								   pop_string!(bytes)
							   else
								   raise ParseError.new("Unknown field type #{type}")
							   end
			end
			fields
		end

		def self.pop_uint!(bytes)
			bytes.slice!(0,4).unpack("L").first
		end

		def self.pop_short!(bytes)
			bytes.slice!(0,2).unpack("S").first
		end

		def self.pop_string!(bytes)
			length = pop_uint!(bytes)
			bytes.slice!(0,length)
		end
	end
end
