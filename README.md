# WeMo Control Center

Simple dashboard of networked WeMo Switches.

## Install

```
$ git clone https://github.com/mnoble/wemo.git
$ cd wemo
$ bundle install
$ rackup
```

### Example

```ruby
wemo = Wemo::Switch.new("http://10.0.0.11:49153/setup.xml")
wemo.on?
# => true
```

## The Code

The `lib` directory is filled with objects that interact with the WeMo
Switch. The process of requesting data from the Switch involves three
things...

### Service

Services are essentially SOAP endpoints the send and receive data from
the WeMo. There's a service to setup the WeMo on your wifi network, one
to request data about the WeMo itself, one for other metadata, etc.

We only care about the `basicevent` service at the moment. This is where
we request data about the Switch and set things like whether it's on or
off.

### Action

A service will have many actions. Each `Wemo::Actions::*` class
represents one of these actions. It has a `name` and a `payload`.

**name**
A camelcase name of the event. Example: GetBinaryState

**payload**
The full XML request body.

### Response

Responses are responsible for taking the raw string response from an
action and turning it into a value of some kind.

