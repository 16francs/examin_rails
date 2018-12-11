module QuestionsService
  # エクセル出力用メソッド
  def excel_render(file)
    excel = RubyXL::Parser.parse(file)
    # エクセルファイルの読み込み
    excel.tap do |workbook|
      workbook.worksheets.each do |worksheet|
        @worksheet = worksheet
        @worksheet.each_with_index do |row, row_num|
          # 1行ずつセルをみていく
          row&.cells&.each do |cell|
            next if cell.nil? # セルが空欄なら次へ

            cell_render(cell) # セルに値があればcell_renderへ
          end
          row_height_auto(row_num)
        end
      end
    end
  end

  private

  def content_eval(content)
    view_context.instance_eval(content).gsub(/\R/, "\n") # エクセルの改行は LF
  end

  # セルへ値を代入するメソッド
  def cell_render(cell)
    cell.change_contents(content_eval(cell.value))
    cell.change_text_wrap(true) if (cell&.value&.lines("\n")&.count) > 1
  rescue StandardError
    # 値がnilの場合エラーメッセージを表示する
    cell.change_contents('error!')
    cell.change_font_color('FF0000')
    cell.change_fill('FFFF00')
  end

  def row_height_auto(row_num)
    max_lines = @worksheet[row_num]&.cells&.map { |cell| cell&.value&.lines("\n")&.count || 0 }&.max
    # 最小値が RubyXL::Row::DEFAULT_HEIGHT (= 13) では合わなかったので手動調整
    origin_height = [@worksheet.get_row_height(row_num), 20].max
    @worksheet.change_row_height(row_num, origin_height * max_lines) if max_lines&.positive?
  end
end
