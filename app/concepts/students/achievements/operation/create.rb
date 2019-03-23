# frozen_string_literal: true

class Students::Achievements::Operation::Create < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!, fail_fast: true

  private

  def validate!(options, params, **)
    achievements = params[:achievements]

    achievements.map! do |achievement|
      contract = Students::Achievements::Contract::Create.new(Achievement.new)

      contract.question_id = achievement[:question_id]
      contract.result = achievement[:result]
      contract.user_choice = achievement[:user_choice]

      raise ApiErrors::ValidationError unless contract.valid?

      contract
    end

    options[:contracts] = achievements
  end

  def persist!(options, params, **)
    contracts = options[:contracts]

    # 中間テーブルの作成
    problems_user = ProblemsUser.create(
      problem_id: params[:problem_id],
      user_id: params[:user_id]
    )

    # 成績の登録
    contracts.each do |contract|
      Achievement.create(
        problems_user_id: problems_user[:id],
        question_id: contract.question_id,
        result: contract.result,
        user_choice: contract.user_choice,
        answer_time: 0 # <- 現在は使用していないため
      )
    end

    options[:model] = problems_user
  end
end
