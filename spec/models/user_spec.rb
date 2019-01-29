# frozen_string_literal: true

describe User, type: :model do
  let(:user) { build(:user) }

  context 'モデルの関連' do
    it { should have_many(:problems) }
    it { should have_many(:problems_users) }
  end
end
