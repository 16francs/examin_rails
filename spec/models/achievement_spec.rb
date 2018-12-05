require 'rails_helper'

RSpec.describe Achievement, type: :model do
  before do
    @achievement = build(:achievement, :with_problems_user, :with_question)
  end

  it 'Achievementの有効性' do
    expect(@achievement).to be_valid
  end

  describe 'Achievementとの関連' do
    it { should belong_to(:problems_user) }
    it { should belong_to(:question) }
  end

  describe 'nilの場合のテスト NG' do
    it 'resultがnil' do
      @achievement[:result] = nil
      expect(@achievement).to_not be_valid
    end

    it 'user_choiceがnil' do
      @achievement[:user_choice] = nil
      expect(@achievement).to_not be_valid
    end

    it 'answer_timeがnil' do
      @achievement[:answer_time] = nil
      expect(@achievement).to_not be_valid
    end
  end

  describe '数値の検証 NG' do
    it 'user_choiceの最大値' do
      @achievement[:user_choice] = 11
      expect(@achievement).to_not be_valid
    end

    it 'user_choiceの最小値' do
      @achievement[:user_choice] = -2
      expect(@achievement).to_not be_valid
    end

    it 'user_choiceは整数' do
      @achievement[:user_choice] = 0.1
      expect(@achievement).to_not be_valid
    end

    it 'answer_timeの最小値' do
      @achievement[:answer_time] = -1
      expect(@achievement).to_not be_valid
    end
  end
end
