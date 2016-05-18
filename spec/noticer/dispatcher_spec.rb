require "spec_helper"

module Noticer
  describe Dispatcher do
    context "with pattern *.stock.# in configuration" do
      let(:configuration) {
        configuration = Configuration.new
        configuration.notification_routes = [
          {
            routing_patterns: ["*.stock.#"],
            callback: -> (routing_key, message) { }
          }
        ]
        configuration
      }
      let(:dispatcher) { Dispatcher.new(configuration) }

      describe "#filtered_callbacks" do
        it "should match eur.stock.db" do
          expect(dispatcher.send(:filtered_callbacks, "eur.stock.db").count).to eq 1
        end

        it "should match usd.stock" do
          expect(dispatcher.send(:filtered_callbacks, "usd.stock").count).to eq 1
        end

        it "should not match stock.nasdaq" do
          expect(dispatcher.send(:filtered_callbacks, "stock.nasdaq").count).to eq 0
        end
      end
    end

    describe "#topic_matches" do
      let(:dispatcher) { Dispatcher.new }

      it "should match when the pattern key is equal to the routing key" do
        expect(dispatcher.send(:topic_matches, "alpha.bravo.charlie", "alpha.bravo.charlie"))
          .to be_truthy
      end

      it "should not match when the pattern key is different from routing key" do
        expect(dispatcher.send(:topic_matches, "alpha.bravo.charlie", "alpha.bravo.delta"))
          .to be_falsey
      end

      it "should match when the pattern key is a single multiple wildcard" do
        expect(dispatcher.send(:topic_matches, "#", "alpha.bravo.charlie"))
          .to be_truthy
      end

      it "should match when the pattern key has a single word wildcard" do
        expect(dispatcher.send(:topic_matches, "alpha.bravo.*", "alpha.bravo.charlie"))
          .to be_truthy
      end

      it "should match when the pattern key has two single word wildcards" do
        expect(dispatcher.send(:topic_matches, "*.bravo.*", "alpha.bravo.charlie"))
          .to be_truthy
      end

      it "should match when the pattern key starts with a multiple word wildcard" do
        expect(dispatcher.send(:topic_matches, "#.charlie", "alpha.bravo.charlie"))
      end
    end
  end
end
