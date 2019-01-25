# frozen_string_literal: true

describe ProblemsUser, type: :model do
  context 'モデルの関連' do
    it { should belong_to(:problem) }
    it { should belong_to(:user) }
    it { should have_many(:achievements) }
  end
end
