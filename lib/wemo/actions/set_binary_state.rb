module Wemo
  module Actions
    class SetBinaryState < Action
      def name
        "SetBinaryState"
      end

      def payload
        <<-XML
<?xml version="1.0" encoding="utf-8"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<s:Body>
  <u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1">
    <BinaryState>#{options[:state]}</BinaryState>
  </u:SetBinaryState>
</s:Body>
</s:Envelope>
        XML
      end
    end
  end
end
