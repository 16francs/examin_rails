# frozen_string_literal: true

describe Achievement, type: :model do
  context 'モデルの関連' do
    it { should belong_to(:problems_user) }
    it { should belong_to(:question) }
  end
end
