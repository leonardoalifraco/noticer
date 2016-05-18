module Noticer
  class Configuration
    attr_accessor :notification_routes

    def initialize
      @notification_routes = []
    end
  end
end
