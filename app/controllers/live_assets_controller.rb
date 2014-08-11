class LiveAssetsController < ApplicationController
  include ActionController::Live

  def ping 
    while true
      response.stream.write DateTime.now.to_s + "\n"
      sleep 1
    end
  rescue IOError
    response.stream.close
  end

  def sse
   begin
    response.headers["Cache-Control"] = "no-cache"
    response.headers["Content-Type"] = "text/event-stream"

    sse = LiveAssets::SSESubscriber.new
    sse.each { |msg| response.stream.write msg }

  rescue IOError
    sse.close
    response.stream.close
  end
  end
end
