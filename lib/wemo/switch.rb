require "base64"

module Wemo
  class Switch
    attr_accessor :location, :attributes

    def self.find(encoded_ip)
      new(Base64.decode64(encoded_ip))
    end

    def initialize(location)
      @location   = location
      @attributes = Hash.from_xml(setup)
    end

    def uuid
      @uuid ||= Base64.encode64(location)
    end

    def name
      attributes["root"]["device"]["friendlyName"]
    end

    def on?
      state == :on
    end

    def off?
      !on?
    end

    def on!
      basic_event.send(Actions::SetBinaryState.new(state: "1"))
    end

    def off!
      basic_event.send(Actions::SetBinaryState.new(state: "0"))
    end

    def set!(state)
      state.to_s == "on" ? on! : off!
    end

    private

    def setup
      Net::HTTP.get(URI.parse("#{schemize(location)}/setup.xml"))
    end

    def schemize(uri)
      uri =~ /^http/ ? uri : "http://#{uri}"
    end

    def state
      basic_event.send(Actions::GetBinaryState.new, Responses::BinaryState)
    end

    def basic_event
      Services::BasicEvent.new(self)
    end
  end
end
