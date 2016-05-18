module Noticer
  class Dispatcher
    def initialize(configuration = nil)
      @configuration = configuration || Configuration.new
    end

    def emit(routing_key, message)
      filtered_callbacks(routing_key).each do |ac|
        ac[:callback].call(routing_key, message)
      end
    end

    private
    def filtered_callbacks(routing_key)
      return @configuration.notification_routes.select do |ac|
        ac[:routing_patterns].any? do |pattern|
          topic_matches(pattern, routing_key)
        end
      end
    end

    def split_topic_key(key)
      key.split(/\./).map(&:to_sym)
    end

    def topic_matches(p, r)
      topic_matches_1(split_topic_key(p), split_topic_key(r))
    end

    def topic_matches_1(p, r)
      p_head, *p_tail = *p
      r_head, *r_tail = *r
      return true if p.size == 1 && p_head == :"#"
      return last_topic_match(p_tail, [], r.reverse) if p_head == :"#"
      return true if p.empty? && r.empty?
      return topic_matches_1(p_tail, r_tail) if p_head == :"*"
      return topic_matches_1(p_tail, r_tail) if p_head == r_head
      false
    end

    def last_topic_match(p, r, a)
      return topic_matches_1(p, r) if a.empty?
      backtrack_next, *backtrack_list = *a
      return topic_matches_1(p, r) || last_topic_match(p, r.unshift(backtrack_next), backtrack_list)
    end
  end
end
