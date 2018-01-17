module Exceptions

  class AppError < StandardError
    attr_reader :data
    def initialize(data = nil)
      super(data)
      @data = data
    end
  end

  class NotFoundError < AppError
    def entity
      data
    end
  end
  
  class DuplicatedEntityError < AppError
    def entity
      data
    end
  end

  class InvalidPasswordError < AppError
  end

  class UnauthorizedError < AppError
  end

  class ResetPasswordCodeExpiredError < AppError
  end

  class AlreadyLinkedToAnotherUserError < AppError
  end

  class OnlyLinkedToThisProviderError < AppError
  end

  class MissingRoleError < AppError
  end

  class DuplicatedRoleError < AppError
  end

  class DisabledUserError < AppError
  end

  class AppVersionExpiredError < AppError
  end

end