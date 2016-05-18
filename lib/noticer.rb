require "noticer/version"
require "noticer/configuration"
require "noticer/dispatcher"

module Noticer
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def emit(routing_key, message)
      @dispatcher ||= Dispatcher.new(configuration)
      @dispatcher.emit(routing_key, message)
    end
  end
end
