require 'rails_helper'

RSpec.describe ProblemsUser, type: :model do
  before do
    @problems_user = build(:problems_user, :with_problem, :with_user)
  end

  it 'ProblemsUserの有効性' do
    expect(@problems_user).to be_valid
  end

  describe 'ProblemsUserとの関連' do
    it { should belong_to(:user) }
    it { should belong_to(:problem) }
    it { should have_many(:achievements) }
  end
end
