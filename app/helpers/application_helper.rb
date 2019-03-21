# frozen_string_literal: true

module ApplicationHelper
  def default_time(time)
    time.strftime('%Y-%m-%dT%H:%M:%S%z')
  end
end
