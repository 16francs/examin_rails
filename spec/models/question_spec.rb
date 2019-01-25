# frozen_string_literal: true

describe Question, type: :model do
  context 'モデルの関連' do
    it { should belong_to(:problem) }
    it { should have_many(:achievements) }
  end
end
