#!/usr/bin/ruby

require_relative 'wl'

if ARGV[0].empty?
	puts "Please provide a Socket"
	exit 1
end

con = WL::Connection.new(ARGV[0])
con.start_event_loop

#wayland = UNIXSocket.new(ARGV[0])
#while (header = wayland.read(8)).size == 8
#	sender = header.byteslice(0,4).unpack("L").first
#	message_size = header.byteslice(6,2).unpack("S").first
#	op_code = header.byteslice(4,2).unpack("S").first
#	puts "New Message recieved from #{sender}"
#	puts "Lenght is #{message_size}"
#	puts "Opcode is #{op_code}"
#	
#	message = wayland.read(message_size-8)
#	name = message[0,4].unpack("L").first
#	interface_name_length = message[4,4].unpack("L").first
#	interface = message[8,interface_name_length]
#	version = message[-4,4].unpack("L").first
#	puts "Message recieved"
#	puts "Name is #{name}"
#	puts "Interface is #{interface}"
#	puts "Version is #{version}"
#	puts "--------------------------"
#end
