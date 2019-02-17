module Channel
  class Channel
    attr_accessor :discussions, :admin

    def initialize(discussions:, admin:)
      @discussions = discussions
      @admin = admin
    end
  end
end
