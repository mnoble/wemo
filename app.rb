require "sinatra/base"
require "upnp/ssdp"
require "net/http"
require "uri"
require "active_support/all"
require "i18n"

module Wemo
  class Application < Sinatra::Base
    get "/" do
      erb :index
    end

    helpers do
      def devices
        UPnP::SSDP.search.
          uniq { |response| response[:location] }.
          map  { |response| Device.new(response[:location]) }.
          sort_by(&:name)
      end
    end
  end

  class Device
    attr_accessor :attributes

    def initialize(xml_location)
      @attributes = Hash.from_xml(Net::HTTP.get(URI(xml_location)))["root"]["device"]
    end

    def name
      attributes["friendlyName"]
    end

    def state
      attributes["binaryState"] == "1" ? "on" : "off"
    end

    def on?
      state == "on"
    end

    def off?
      state == "off"
    end
  end
end
