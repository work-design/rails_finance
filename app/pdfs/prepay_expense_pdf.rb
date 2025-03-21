class PrepayExpensePdf < BasePdf

  attr_reader :document, :expense_member

  def initialize(expense_member_id: nil)
		super
    @expense_member = ExpenseMember.find expense_member_id
	end

	def run
		write_content
	end

  def render
    @document.render
  end

  def write_content
    stroke do
      dash [8, 4]
      horizontal_line -36, (margin_box.width + 36), at: (160.mm - 36)
      horizontal_line -36, (margin_box.width + 36), at: (99.mm - 36)
    end
    write_header
    write_table_header
    write_content_table
    write_table_footer
  end

  def write_header
    undash
    text "<u>费 用 报 销 单</u>", header_style.merge(inline_format: true)
    move_down 10
  end

  def write_table_header
    grid_table(
      [
        ["单位：#{expense_member.member.office.company_name}", { rowspan: 2, content: expense_member.created_at.to_date.strftime('%Y 年 %m 月 %d 日') }],
        ["部门：#{expense_member.member.department.full_name}"]
      ]
    )
    move_down 10
  end

  def write_content_table
    content_table(
      [
        ['摘要', { colspan: 3, content: expense_member.expense.subject }],
        [ { content: '费用说明' }, { colspan: 3, content: expense_member.details }],
        [ { content: '金额' }, { content: "¥#{expense_member.amount}" }, { colspan: 2, content: expense_member.amount_cn }],
        [ '附单据张数', expense_member.expense.invoices_count, '领款人签章', '' ]
      ]
    ) do
      row(0).style PdfTableHelper::NORMAL_TD
      row(1).style PdfTableHelper::NORMAL_TD.merge height: 90
      row(2..-1).style PdfTableHelper::NORMAL_TD
    end
  end

  def write_table_footer
    footer_table(
      [
        ['审批人', '审核', '出纳', "报销人：#{expense_member.member.name}"]
      ]
    )
  end

end
