# frozen_string_literal: true

class Teachers::Students::Operation::Create < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!

  private

  def validate!(options, params, **)
    contract = Teachers::Students::Contract::Create.new(User.new)

    contract.login_id = params[:student][:login_id]
    contract.name = params[:student][:name]
    contract.school = params[:student][:school]

    options[:contract] = contract
    contract.valid?
  end

  def persist!(options, **)
    contract = options[:contract]

    # パスワードは login_id と同じ
    # 権限は 講師権限 で登録 ( 1: 講師, 2: 管理者 )
    model = User.create(
      login_id: contract.login_id,
      name: contract.name,
      school: contract.school,
      password: contract.login_id,
      password_confirmation: contract.login_id,
      role: 0,
      activated: true
    )

    options[:model] = model
  end
end
