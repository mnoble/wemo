module Wemo
  module Repository
    extend self

    def empty?
      devices.empty?
    end

    def add(device)
      devices << device
    end

    def devices
      @devices ||= []
    end
  end
end
