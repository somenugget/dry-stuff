module Channel
  class User
    attr_accessor :role, :email

    def initialize(role:, email:)
      @role = role
      @email = email
    end
  end
end
