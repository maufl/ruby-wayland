module WL
	module Interface
		class Base
			
			def self.opcodes
				@opcodes ||= []
			end

			def self.event(name, parameters)
				define_method("on_#{name}") do |&block|
					on(name, &block)
				end
				define_method("fire_#{name}") do |args|
					fire(name, args)
				end
				self.singleton_class.class_eval do
					define_method("sig_#{name}") do
						parameters
					end
				end
				self.opcodes << name
			end

			def self.unpack(event, bytes)
				event = self.opcodes[event] if event.is_a? Fixnum
				Message.build(bytes, sig(event))
			end
			
			def self.sig(event)
				event = opcodes[event] if event.is_a? Fixnum
				send("sig_#{event}")
			end

			def initialize(id)
				@id = id
				@callbacks = {}
			end

			def on(event, &block)
				event = self.class.opcodes[event] if event.is_a? Fixnum
				@callbacks[event] ||= []
				@callbacks[event] << block
				@callbacks[event].length - 1
			end

			def fire(event, args)
				event = self.class.opcodes[event] if event.is_a? Fixnum
				@callbacks[event] ||= []
				@callbacks[event].each do |block|
					block.call args
				end
			end

			def invoke(event, args)
				event = @opcode[event] if event.is_a? Fixnum
			end
		end
		class WL_DISPLAY < Base
			event :global, [ [ :uint, :name ], [:string, :interface ], [ :uint, :version ] ]

		end
	end
end
