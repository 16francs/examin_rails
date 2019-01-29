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
    contract.password = params[:student][:password]
    contract.password_confirmation = params[:student][:password_confirmation]

    options[:contract] = contract
    contract.valid?
  end

  def persist!(options, **)
    contract = options[:contract]

    model = User.new(
      login_id: contract.login_id,
      name: contract.name,
      school: contract.school,
      password: contract.password,
      password_confirmation: contract.password_confirmation,
      role: 0,
      activated: true
    )

    options[:model] = model
    model.save!
  end
end
