require 'helper'
require 'fluent/test/driver/input'

class AggregateFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    interval 1s
    server localhost
    port 3000
    tag tcp_socket
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::Driver::Input.new(Fluent::TCPSocketClientInput).configure(conf)
  end

  def test_input(data)
    expected, target = data
    inputs = [
     '{"key":"val"}' 
    ]
    d = create_driver(CONFIG)
    d.run(default_tag: 'test.input') do
      inputs.each do |dat|
        d.feed dat
      end
    end
    assert_equal expected, d.filtered.map{|e| e.last}.length
  end

end
