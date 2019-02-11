# frozen_string_literal: true

class Teachers::Problems::Operation::Create < ApplicationOperation
  step :validate!
  failure :handle_validation_error!, fail_fast: true
  step :persist!
  failure :handle_internal_error!

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

    # タグ登録
    tags = []
    contract.tags.each do |tag|
      if Tag.pluck(:content).include?(tag)
        tags << Tag.find_by(content: tag)
      else
        tags << Tag.create(content: tag)
      end
    end

    # タグと問題集の関連づけ
    tags.map do |tag|
      ProblemsTag.create(
        problem_id: problem[:id],
        tag_id: tag[:id]
      )
    end
  end
end
