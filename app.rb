require "bundler/setup"
require "sinatra/base"
require "upnp/ssdp"
require "net/http"
require "uri"
require "active_support/all"
require "i18n"
require "pry"
require_relative "lib/wemo"
UPnP.log = false

module Wemo
  class Application < Sinatra::Base
    get "/" do
      erb :index
    end

    helpers do
      def wemos
        devices("urn:Belkin:device:controllee:1")
      end

      def devices(type)
        UPnP::SSDP.search(type).uniq.map { |res| Wemo::Switch.new(res[:location]) }.sort_by(&:name)
      end
    end
  end
end
