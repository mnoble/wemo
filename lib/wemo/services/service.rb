module Wemo
  module Services
    class Service
      attr_accessor :device

      def initialize(device)
        @device = device
      end

      def send(action, response_class)
        response_class.new %x(#{build(action)})
      end

      def build(action)
        %(curl -X POST #{headers(action)} --data '#{action.payload}' -s #{service_url})
      end

      def headers(action)
        %(-H 'Content-type: text/xml; charset="utf-8"' -H 'SOAPACTION: "#{service_id}##{action.name}"')
      end

      def service_url
        "#{device.location}#{control_uri}"
      end
    end
  end
end
