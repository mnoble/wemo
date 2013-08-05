module Wemo
  module Responses
    class BinaryState
      include Comparable

      attr_accessor :data

      def initialize(response)
        @data = Hash.from_xml(response)["Envelope"]["Body"]
      end

      def <=>(other)
        value <=> other
      end

      def value
        data["GetBinaryStateResponse"]["BinaryState"] == "1" ? :on : :off
      end

      def inspect
        value
      end

      def to_s
        value.to_s
      end
    end
  end
end
