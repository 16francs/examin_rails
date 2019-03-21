# frozen_string_literal: true

class ApplicationService
  attr_reader :response

  def initialize
    @response = {}
  end

  def default_time(time)
    time.strftime('%Y-%m-%dT%H:%M:%S%z')
  end
end
