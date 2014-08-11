require "live_assets/engine"
require "thread"
require "listen"
#require_relative 'live_assets/sse_subscriber'

module LiveAssets
  autoload :SSESubscriber, "live_assets/sse_subscriber"

  mattr_reader :subscribers
  @@subscribers = []

  def self.subscribe(subscriber)
    subscribers << subscriber
  end
  # Unsubscribe an existing subscriber.
  def self.unsubscribe(subscriber)
    subscribers.delete(subscriber)
  end
  # Start a listener for the following directories.
  # Every time a change happens, publish the given
  # event to all subscribers available.
  def self.start_listener(event, directories)
    Thread.new do
      listener = Listen.to(*directories, latency: 0.5) do |_modified, _added, _removed|
        puts "MODIFIED FILE: #{_modified}"
        subscribers.each { |s| s << event }
      end
      listener.start
    end
  end
end
  
