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

    post "/wemos/:uuid/:state" do
      wemo = Wemo::Switch.find(params[:uuid])
      wemo.set! params[:state]
      status 200
    end

    helpers do
      def wemos
        Wemo::Radar.new("urn:Belkin:device:controllee:1").scan
      end
    end
  end
end
