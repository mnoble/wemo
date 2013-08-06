module Wemo
  class Radar
    attr_accessor :device_type

    def initialize(device_type)
      @device_type = device_type
    end

    def scan
      locations.map { |location| Wemo::Switch.new(location) }.sort_by(&:name)
    end

    def locations
      UPnP::SSDP.search(device_type).uniq.map { |attrs| without_path(attrs[:location]) }
    end

    def without_path(uri)
      uri.gsub %r(/[^/]*$), ""
    end
  end
end
