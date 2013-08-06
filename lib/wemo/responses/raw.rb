module Wemo
  module Responses
    class Raw
      attr_accessor :response

      def initialize(response)
        @response = Hash.from_xml(response)
      end
    end
  end
end
