module Wemo
  class Switch
    attr_accessor :location, :attributes

    def initialize(uri)
      @location   = uri.gsub %r(/[^/]*$), ""
      @attributes = Hash.from_xml(Net::HTTP.get(URI(uri)))
    end

    def name
      device_attributes["friendlyName"]
    end

    def on?
      state == :on
    end

    def off?
      !on?
    end

    private

    def state
      basic_service.send(Actions::GetBinaryState, Responses::BinaryState)
    end

    def basic_service
      Services::BasicService.new(self)
    end

    def device_attributes
      attributes["root"]["device"]
    end
  end
end
