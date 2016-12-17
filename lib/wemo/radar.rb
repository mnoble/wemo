module Wemo
  class Radar
    attr_accessor :device_type, :repository

    def initialize(device_type, repository)
      @device_type = device_type
      @repository = repository
    end

    def scan
      locations.map { |location| repository.add Wemo::Switch.new(location) }
    end

    private

    def locations
      UPnP::SSDP.search(device_type).uniq.map { |attrs| without_path(attrs[:location]) }
    end

    def without_path(uri)
      uri.gsub %r(/[^/]*$), ""
    end
  end
end
