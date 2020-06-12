require 'fluent/input'
module Fluent
class TCPSocketClientInput < Input
  Plugin.register_input('tcp_socket_client', self)

  config_param :format, :string, :default => 'json' # (json|text|ltsv)
  config_param :server, :string, :default => 'localhost'
  config_param :port, :integer, :default => 3000
  config_param :tag, :string, :default => 'tcp_socket'
  config_param :emit_messages, :integer, :default => 10
  config_param :interval, :time, :default => 60
  config_param :add_prefix, :string, :default => nil
  config_param :add_suffix, :string, :default => nil
  config_param :delimiter, :string, :default => "\n"
  
  helpers :timer

  def initialize
    super
    require 'socket'
  end

  def configure(conf)
    super

    log.info "server has been set : #{@server}:#{@port}"

    case @format
    when 'json'
      require 'oj'
    when 'ltsv'
      require 'ltsv'
    when 'msgpack'
      require 'msgpack'
    end
  end

  def multi_workers_ready?
    true
  end

  def start
    super
    timer_execute(:read_socket_run, @interval, repeat: true, &method(:read_socket_messages))
  end

  def read_socket_messages
     es = MultiEventStream.new
     log.trace "Creating socket to #{@server}:#{@port}"
     begin
      socket = TCPSocket.open(@server, @port)
      count=0
      while message = socket.gets(@delimiter)
        es.add(Time.now.to_i, parse_msg(message.chomp(@delimiter)))
        count+=1
        if (count % @emit_messages) == 0
          unless es.empty?
            router.emit_stream(tag, es)
          end
          es = MultiEventStream.new
        end
      end
     rescue Exception => e
       $log.error e
     end

      unless es.empty?
         router.emit_stream(tag, es)
      end
  end

  def parse_msg(record)
    parsed_record = {}
    case @format
    when 'json'
      parsed_record = Oj.load(record)
    when 'ltsv'
      parsed_record = LTSV.parse(record)
    when 'msgpack'
      parsed_record = MessagePack.unpack(record)
    when 'text'
      parsed_record["message"] = record
    end
    parsed_record
  end
end
end
