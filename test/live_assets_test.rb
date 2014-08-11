require 'test_helper'
require 'fileutils'

class LiveAssetsTest < ActiveSupport::TestCase
  setup do
    FileUtils.mkdir_p "test/tmp"
  end

  teardown do
    FileUtils.rm_rf "test/tmp"
  end

  test "can subscribe to existing reloadCSS events" do
    subscriber = []
    LiveAssets.subscribe(subscriber)
    begin
      while subscriber.empty?
        FileUtils.touch("test/dummy/app/assets/stylesheets/application.css")
      end
      assert_includes subscriber, :reloadCSS
    ensure
      LiveAssets.unsubscribe(subscriber)
    end
  end

  test "receives timer notifications" do
    # Create a timer
    l = LiveAssets.start_timer(:ping, 0.5)
    # Our subscriber is a simple array
    subscriber = []
    LiveAssets.subscribe(subscriber)
    begin
      # Wait until we get an event
      true while subscriber.empty?
      assert_includes subscriber, :ping
    ensure
      # Clean up
      LiveAssets.unsubscribe(subscriber)
    end
  end
end


