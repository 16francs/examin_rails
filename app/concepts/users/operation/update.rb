# frozen_string_literal: true

class Users::Operation::Update < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!

  private

  def validate!(options, params, **)
    contract = Users::Contract::Update.new(User.new)

    contract.id = params[:id]
    contract.login_id = params[:user][:login_id]
    contract.name = params[:user][:name]
    contract.school = params[:user][:school]

    options[:contract] = contract
    contract.valid?
  end

  def persist!(options, **)
    contract = options[:contract]

    model = User.find(contract.id)
    model.update(
      login_id: contract.login_id,
      name: contract.name,
      school: contract.school
    )

    options[:model] = model
  end
end
