module Wemo
  module Actions
    class Action
      attr_accessor :options

      def initialize(options={})
        @options = options
      end
    end
  end
end
