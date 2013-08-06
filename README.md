# WeMo Control Center

Simple dashboard of networked WeMo Switches.

### Install

```
$ git clone https://github.com/mnoble/wemo.git
$ cd wemo
$ bundle install
```

### Dashboard Usage

```
$ rackup
```

### The API

The main thing you'll work with is a `Wemo::Switch` object. A `Switch`
represents a physical WeMo switch on your network. They're identified by
the IP address and port the switch lives at.

```ruby
switch = Wemo::Switch.new("10.0.0.11:49153")

switch.on?  # => true
switch.off? # => false

switch.on!
switch.off!
```

#### The Radar

If you don't know the specific location of WeMos on your network, you
can discover them using `Wemo::Radar`. A `Radar` is initialized with the
device type you want to find.

```ruby
radar = Wemo::Radar.new("urn:Belkin:device:controllee:1")
radar.scan # => [#<Wemo::Switch:0x007f8>, #<Wemo::Switch:0x007f9>]
```

#### Services

WeMo Switches have a series of Services they offer. These are SOAP
endpoints used to retrieve or manipulate data about the Switch.

We only care about one service, for now, BasicEvent service. This is
the one used to turn the switch on and off.

Creating a service, in terms of the code, means subclassing
`Wemo::Services::Service` and implementing two methods, `service_id` and
`control_uri`.

```ruby
class BasicEvent < Wemo::Services::Service
  def service_id
    "urn:Belkin:service:basicevent:1"
  end

  def control_uri
    "/upnp/control/basicevent1"
  end
end
```

#### Actions

Each Service implements many actions. The BasicEvent service mentioned
above has two actions that we care about, `GetBinaryState` and
`SetBinaryState`.

Adding new Actions to the library is similar to adding new Services.
Subclass `Wemo::Actions::Action` and implement `name` and `payload`.
Actions are instantiated with an options hash that `payload` can then
use.

```ruby
class GetBinaryState < Wemo::Actions::Action
  def name
    "GetBinaryState"
  end

  def payload
    <<-XML
<?xml version="1.0" encoding="utf-8"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<s:Body>
<u:GetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"></u:GetBinaryState>
</s:Body>
</s:Envelope>
    XML
  end
end
```

#### Responses

The WeMo will send back an XML payload, Responses will need to parse out 
any data from that which is relevant.

Services will use the `Wemo::Responses::Raw` response by default. It just 
collects the response, parses the XML into a Hash and nothing more.

Building new responses is just a matter of implementing a class that
takes a string in it's initializer.

```ruby
class RawResponse
  def initialize(response)
    @data = Hash.from_xml(response)
  end
end
```

#### Discovering New Services/Actions

Services and Actions are specific to a type of device. You can explore
them all by looking through the various XML documents exposed by
devices. To get to these documents, comb through
`Wemo::Switch#attributes`. Specifically,
`attributes["root"]["serviceList"]["service"]` and the accompanying
`SCPDURL` attributes. Yea... SOAP is awesome,
isn't it? </sarcasm>

```ruby
wemo = Wemo::Switch.new("10.0.0.11:49153")
wemo.attributes
# => { ...Gigantic list of attributes and crap... }
```

```
