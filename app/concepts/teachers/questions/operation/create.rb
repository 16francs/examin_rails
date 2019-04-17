# frozen_string_literal: true

class Teachers::Questions::Operation::Create < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!, fail_fast: true

  private

  def validate!(options, params, **)
    contract = Teachers::Questions::Contract::Create.new(Question.new)

    contract.problem_id = params[:problem_id]
    contract.sentence = params[:question][:sentence]
    contract.correct = params[:question][:correct]

    options[:contract] = contract
    contract.valid?
  end

  def persist!(options, **)
    contract = options[:contract]

    # 問題登録
    model = Question.create(
      problem_id: contract.problem_id,
      sentence: contract.sentence,
      correct: contract.correct
    )

    options[:model] = model
  end
end
