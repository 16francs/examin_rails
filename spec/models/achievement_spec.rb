require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'Achievementとの関連' do
    it { should belong_to(:problems_user) }
    it { should belong_to(:question) }
  end
end
