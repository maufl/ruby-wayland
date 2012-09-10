require 'nokogiri'

module WL

	module Parser
		def self.parse_default
			parse("/usr/share/doc/wayland/wayland.xml")
		end
		def self.parse(file)
			f = File.open(file)
			spec = Nokogiri::XML(f)
			f.close

			spec.xpath("/protocol/interface").each do |i|
				events = {}
				i.xpath("event").each do |e|
					args = []
					e.xpath("arg").each do |a|
						args << [ a["type"], a["name"] ]
					end
					events.merge!({ e["name"] => args })
				end
				new_interface = Class.new(WL::Interface::Base) do
					events.each do |name, args|
						event name, args
					end
				end
				WL::Interface.const_set(i["name"].upcase, new_interface)
			end
		end
	end

end
