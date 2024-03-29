require "live_assets/engine"
require "thread"
require "listen"
#require_relative 'live_assets/sse_subscriber'

module LiveAssets
  extend ActiveSupport::Autoload

  #autoload :SSESubscriber, "live_assets/sse_subscriber"
  eager_autoload do
    autoload :SSESubscriber
  end

  mattr_reader :subscribers
  @@subscribers = []
  @@mutex = Mutex.new

  def self.subscribe(subscriber)
    @@mutex.synchronize do
      subscribers << subscriber
    end
  end
  # Unsubscribe an existing subscriber.
  def self.unsubscribe(subscriber)
    @@mutex.synchronize do
      subscribers.delete(subscriber)
    end
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

  def self.start_timer(event, time)
    Thread.new do
      while true
        subscribers.each { |s| s << event }
        sleep(time)
      end
    end
  end
end

