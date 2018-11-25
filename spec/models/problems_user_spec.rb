require 'rails_helper'

RSpec.describe ProblemsUser, type: :model do
  describe 'ProblemsUserとの関連' do
    it { should belong_to(:user) }
    it { should belong_to(:problem) }
    it { should have_many(:achievements) }
  end
end
