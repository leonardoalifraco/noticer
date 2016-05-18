require 'spec_helper'

describe Noticer do
  it "has a version number" do
    expect(Noticer::VERSION).not_to be nil
  end

  it "has the current version number" do
    expect(Noticer::VERSION).to eq "0.2.0"
  end

  describe "#emit" do
    context "without configuration" do
      it "shouldn't dispatch messages since there are no routing_patterns defined" do
        Noticer.emit("some.pattern", "some.message")
      end
    end

    context "with configuration" do
      let(:message_1) { "message_1" }
      let(:stub_1) { double() }
      let(:stub_2) { double() }

      before do
        Noticer.configure do |config|
          config.notification_routes = [
            {
              routing_patterns: ["tree.green"],
              callback: -> (routing_key, message) {
                stub_1.notify(message)
              }
            },
            {
              routing_patterns: ["tree.*"],
              callback: -> (routing_key, message) {
                stub_2.notify(routing_key, message)
              }
            }
          ]
        end
      end

      it "should dispatch only the matched messages" do
        routing_key = "tree.green"
        expect(stub_1).to receive(:notify).with(message_1)
        expect(stub_2).to receive(:notify).with(routing_key, message_1)
        Noticer.emit(routing_key, message_1)
      end

      it "should dispatch only the matched messages" do
        routing_key = "tree.red"
        expect(stub_1).to_not receive(:notify)
        expect(stub_2).to receive(:notify).with(routing_key, message_1)
        Noticer.emit(routing_key, message_1)
      end
    end
  end

  describe "#configure" do
    let(:sample_patterns) { ["*.stock.#"] }
    before do
      Noticer.configure do |config|
        config.notification_routes = [
          {
            routing_patterns: sample_patterns,
            callback: -> (routing_key, message) { }
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
