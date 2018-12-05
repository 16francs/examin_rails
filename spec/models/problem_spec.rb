require 'rails_helper'

RSpec.describe Problem, type: :model do
  before do
    @problem = build(:problem, :with_user)
  end

  it 'Problemの有効性' do
    expect(@problem).to be_valid
  end

  describe 'Problemとの関連' do
    it { should belong_to(:user) }
    it { should have_many(:problems_users) }
    it { should have_many(:users) }
    it { should have_many(:questions) }
  end

  describe 'nilの場合のテスト NG' do
    it 'titleがnil' do
      @problem[:title] = nil
      expect(@problem).to_not be_valid
    end

    it 'contentがnil' do
      @problem[:content] = nil
      expect(@problem).to_not be_valid
    end
  end

  describe '長さの検証 NG' do
    it 'titleの最大値' do
      @problem[:title] = 'a' * 31
      expect(@problem).to_not be_valid
    end

    it 'contentの最大値' do
      @problem[:content] = 'a' * 61
      expect(@problem).to_not be_valid
    end
  end
end
