module Wemo
  module Services
    class BasicEvent < Service
      def service_id
        "urn:Belkin:service:basicevent:1"
      end

      def control_uri
        "/upnp/control/basicevent1"
      end
    end
  end
end
