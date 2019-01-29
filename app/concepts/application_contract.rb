# frozen_string_literal: true

class ApplicationContract < Reform::Form
  include Reform::Form::ActiveRecord
  require 'reform/form/validation/unique_validator'

  # 一般的な入力表現
  VALID_VALUE_REGEX = /\A[ぁ-んーァ-ンー-龥々a-zａ-ｚA-ZＡ-Ｚ]+\z/.freeze
  # ユーザーID
  VALID_ENGLISH_REGEX = /\A[a-zA-Z0-9]+\z/.freeze
end
