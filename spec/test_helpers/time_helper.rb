# frozen_string_literal: true

require 'rails_helper'

module TimeHelper
  def default_time(time)
    time.strftime('%Y-%m-%d %H:%M:%S')
  end
end
