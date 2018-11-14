require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  it 'Userの有効性' do
    expect(@user).to be_valid
  end

  describe 'Userとの関連' do
    it { should have_many(:api_keys) }
    it { should have_many(:problems) }
  end

  describe 'nilの場合のテスト NG' do
    it 'login_idがnil NG' do
      @user[:login_id] = nil
      expect(@user).to_not be_valid
    end

    it 'nameがnil' do
      @user[:name] = nil
      expect(@user).to_not be_valid
    end

    it 'schoolがnil' do
      @user[:school] = nil
      expect(@user).to_not be_valid
    end
  end

  describe '長さの検証 NG' do
    it 'login_idの最大値' do
      @user[:login_id] = 'a' * 33
      expect(@user).to_not be_valid
    end

    it 'nameの最大値' do
      @user[:name] = 'a' * 33
      expect(@user).to_not be_valid
    end

    it 'schoolの最大値' do
      @user[:school] = 'a' * 33
      expect(@user).to_not be_valid
    end
  end

  describe 'ユニーク値の検証 NG' do
    before do
      @other_user = create(:user)
    end

    it 'login_idがユニーク' do
      @user[:login_id] = @other_user[:login_id]
      expect(@user).to_not be_valid
    end
  end

  describe 'activate' do
    before do
      @user.save
      @api_key = @user.activate
    end

    describe 'api_keyが存在しない場合' do
      it 'ログイン処理' do
        expect(@api_key).to_not eq(nil)
      end
    end

    describe 'api_keyが存在する場合' do
      it 'ログイン中でない場合' do
        @api_key[:activated] = false
        @api_key.save
        expect(@api_key[:activated]).to eq(false)
        # 未ログイン時のテスト
        @api_key = @user.activate
        expect(@api_key[:activated]).to eq(true)
      end

      it '有効期限がきれている場合' do
        @api_key[:expires_at] = DateTime.now - 1
        @api_key.save
        expect(@api_key.before_expired?).to eq(false)
        # 有効期限切れの場合のテスト
        @api_key = @user.activate
        expect(@api_key.before_expired?).to eq(true)
      end
    end
  end
end
