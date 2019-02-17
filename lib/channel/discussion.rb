module Channel
  class Discussion
    attr_accessor :title, :users

    def initialize(title:, users:)
      @title = title
      @users = users
    end
  end
end
