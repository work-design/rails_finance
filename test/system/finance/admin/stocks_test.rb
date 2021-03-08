require "application_system_test_case"

class StocksTest < ApplicationSystemTestCase
  setup do
    @finance_admin_stock = finance_admin_stocks(:one)
  end

  test "visiting the index" do
    visit finance_admin_stocks_url
    assert_selector "h1", text: "Stocks"
  end

  test "creating a Stock" do
    visit finance_admin_stocks_url
    click_on "New Stock"

    fill_in "Amount", with: @finance_admin_stock.amount
    fill_in "Expense amount", with: @finance_admin_stock.expense_amount
    fill_in "Note", with: @finance_admin_stock.note
    fill_in "Ratio", with: @finance_admin_stock.ratio
    click_on "Create Stock"

    assert_text "Stock was successfully created"
    click_on "Back"
  end

  test "updating a Stock" do
    visit finance_admin_stocks_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @finance_admin_stock.amount
    fill_in "Expense amount", with: @finance_admin_stock.expense_amount
    fill_in "Note", with: @finance_admin_stock.note
    fill_in "Ratio", with: @finance_admin_stock.ratio
    click_on "Update Stock"

    assert_text "Stock was successfully updated"
    click_on "Back"
  end

  test "destroying a Stock" do
    visit finance_admin_stocks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Stock was successfully destroyed"
  end
end
