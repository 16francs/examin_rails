# frozen_string_literal: true

module ApiErrors
  class BadRequest < StandardError
  end

  class Unauthorized < StandardError
  end

  class Forbidden < StandardError
  end

  class ValidationError < StandardError
  end

  class OperationError < StandardError
  end
end
