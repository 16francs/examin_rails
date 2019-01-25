# frozen_string_literal: true

describe Problem, type: :model do
  context 'モデルの関連' do
    it { should belong_to(:user) }
    it { should have_many(:problems_users) }
    it { should have_many(:users) }
    it { should have_many(:questions) }
  end
end
