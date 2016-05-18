require "spec_helper"

module Noticer
  describe Configuration do
    describe "#notification_routes" do
      it "default value is an empty array" do
        expect(Configuration.new.notification_routes).to be_eql([])
      end
    end
  end
end
