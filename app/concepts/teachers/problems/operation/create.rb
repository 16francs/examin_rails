# frozen_string_literal: true

class Teachers::Problems::Operation::Create < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!, fail_fast: true

  private

  def validate!(options, params, **)
    contract = Teachers::Problems::Contract::Create.new(Problem.new)

    contract.title = params[:problem][:title]
    contract.content = params[:problem][:content]
    contract.tags = params[:problem][:tags]

    options[:contract] = contract
    contract.valid?
  end

  def persist!(options, params, **)
    contract = options[:contract]

    # 問題集登録
    problem = Problem.create(
      title: contract.title,
      content: contract.content,
      user_id: params[:current_user][:id]
    )

    tags = Tag.pluck(:content)
    contract.tags.map do |content|
      # タグの登録
      tag = tags.include?(content) ? Tag.find_by(content: content) : Tag.create(content: content)

      # タグと問題集の関連づけ
      ProblemsTag.create(problem_id: problem[:id], tag_id: tag[:id])
    end

    options[:model] = problem
  end
end
