require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  before do
    @user = create(:user)
    @api_key = @user.activate
  end

  it 'ApiKeyの有効性' do
    expect(@api_key).to be_valid
  end

  describe 'ApiKeyとの関連' do
    it { should belong_to(:user) }
  end

  describe 'before_expired?' do
    it '有効期限内' do
      expect(@api_key.before_expired?).to eq(true)
    end

    it '有効期限切れ' do
      @api_key[:expires_at] = DateTime.now - 1
      expect(@api_key.before_expired?).to eq(false)
    end
  end

  it 'set_activated' do
    @api_key.set_activated
    expect(@api_key[:activated]).to eq(true)
  end

  it 'set_expiration' do
    @api_key.set_expiration
    expect(@api_key[:expires_at]).to_not eq(nil)
  end
end
