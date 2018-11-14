require 'rails_helper'

RSpec.describe Answer, type: :model do
  before do
    @answer = build(:answer, :with_question)
  end

  it 'Answerの有効性' do
    expect(@answer).to be_valid
  end

  describe 'Answerとの関連' do
    it { should belong_to(:question) }
  end

  describe 'nilの場合のテスト NG' do
    it 'choiceがnil' do
      @answer[:choice] = nil
      expect(@answer).to_not be_valid
    end
  end

  describe '長さの検証' do
    it 'choiceの最大値' do
      @answer[:choice] = 'a' * 201
      expect(@answer).to_not be_valid
    end
  end
end
