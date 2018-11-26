require 'rails_helper'

RSpec.describe Question, type: :model do
  before do
    @question = build(:question, :with_problem)
  end

  it 'Questionの有効性' do
    expect(@question).to be_valid
  end

  describe 'Questionとの関連' do
    it { should belong_to(:problem) }
    it { should have_many(:achievements) }
    it { should have_many(:answers) }
  end

  describe 'nilの場合のテスト NG' do
    it 'sentenceがnil' do
      @question[:sentence] = nil
      expect(@question).to_not be_valid
    end

    it 'typeがnil' do
      @question[:type] = 0
      expect(@question).to_not be_valid
    end

    it 'correctがnil' do
      @question[:correct] = nil
      expect(@question).to_not be_valid
    end
  end

  describe '長さの検証 NG' do
    it 'sentenceの最大値' do
      @question[:sentence] = 'a' * 201
      expect(@question).to_not be_valid
    end
  end

  describe '数値の検証 NG' do
    it 'typeの最小値' do
      @question[:type] = 0
      expect(@question).to_not be_valid
    end

    it 'typeの最大値' do
      @question[:type] = 10
      expect(@question).to_not be_valid
    end

    it 'typeは整数' do
      @question[:type] = 0.1
      expect(@question).to_not be_valid
    end
  end
end
