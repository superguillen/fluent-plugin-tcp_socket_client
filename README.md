# fluent-plugin-tcp_socket_client , a plugin for [Fluentd](http://fluentd.org)
[![Build Status](https://api.travis-ci.org/superguillen/fluent-plugin-tcp_socket_client.svg?branch=master)](https://api.travis-ci.org/superguillen/fluent-plugin-tcp_socket_client)

A fluentd input plugin for read TCP socket.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-tcp_socket_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-tcp_socket_client --no-document

## Requirements

- Ruby 2.1 or later
- fluentd v0.12 or later

## Usage
### Input plugin (@type 'tcp_socket_client')

Read events from TCP sockets.

```
<source>
  @type tcp_socket_client
  @log_level debug
  server localhost
  port 3000
  tag prueba
  interval 1s
  format text
</source>
```
### Common parameters
### interval
Interval for retry connect to socket.
```
interval 5s
```
### server
Socket server name or IP address.
```
server localhost
```
### port
Socket port.
```
port 3000
```
### format
#### Default: json
Format of the message (json|text|ltsv)
```
format json
```
### Example
```
<system>
  workers 1
</system>
<source>
  @type tcp_socket_client
  server localhost
  port 3000
  tag prueba
  interval 1s
  format json
</source>
<match prueba>
  @type stdout
</match>
```
In another terminal run:
```
require 'socket'
puts "Starting the Server..................."
server = TCPServer.open(3000) # Server would listen on port 3000
loop{                         # Servers run forever
   client_connection = server.accept # Establish client connect connection
   client_connection.puts('{"key":"val"}')
   client_connection.close      # Disconnect from the client
}
```
