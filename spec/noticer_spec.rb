require 'spec_helper'

describe Noticer do
  it 'has a version number' do
    expect(Noticer::VERSION).not_to be nil
  end

  describe "#configure" do
    let(:sample_patterns) { ["*.stock.#"] }
    before do
      Noticer.configure do |config|
        config.notification_routes = [
          {
            routing_patterns: sample_patterns,
            callback: -> (routing_key, message) {
              nil
            }
          }
        ]
      end
    end

    it "returns the configured routing patterns" do
      notification_routes = Noticer.configuration.notification_routes

      expect(notification_routes).to be_a(Array)
      expect(notification_routes.size).to eq(1)
      expect(notification_routes.first[:routing_patterns]).to eq(sample_patterns)
    end
  end
end
