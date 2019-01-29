# frozen_string_literal: true

module ApplicationHelper
  def default_time(time)
    time.strftime('%Y-%m-%d %H:%M:%S')
  end
end
