# frozen_string_literal: true

describe ProblemsTag, type: :model do
  context 'モデルの関連' do
    it { should belong_to(:problem) }
    it { should belong_to(:tag) }
  end
end
