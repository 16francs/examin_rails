# frozen_string_literal: true

describe Tag, type: :model do
  context 'モデルの関連' do
    it { should have_many(:problems_tags) }
    it { should have_many(:problems) }
  end
end
