# frozen_string_literal: true

class Teachers::Teachers::Operation::Create < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!

  private

  def validate!(options, params, **)
    contract = Teachers::Teachers::Contract::Create.new(User.new)

    contract.login_id = params[:teacher][:login_id]
    contract.name = params[:teacher][:name]
    contract.school = params[:teacher][:school]
    contract.password = params[:teacher][:password]
    contract.password_confirmation = params[:teacher][:password_confirmation]

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
      role: 1,
      activated: true
    )

    options[:model] = model
    model.save!
  end
end
