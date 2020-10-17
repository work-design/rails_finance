require "application_system_test_case"

class FundBudgetsTest < ApplicationSystemTestCase
  setup do
    @finance_admin_fund_budget = finance_admin_fund_budgets(:one)
  end

  test "visiting the index" do
    visit finance_admin_fund_budgets_url
    assert_selector "h1", text: "Fund Budgets"
  end

  test "creating a Fund budget" do
    visit finance_admin_fund_budgets_url
    click_on "New Fund Budget"

    fill_in "Amount", with: @finance_admin_fund_budget.amount
    fill_in "Financial", with: @finance_admin_fund_budget.financial_id
    fill_in "Financial type", with: @finance_admin_fund_budget.financial_type
    fill_in "Note", with: @finance_admin_fund_budget.note
    click_on "Create Fund budget"

    assert_text "Fund budget was successfully created"
    click_on "Back"
  end

  test "updating a Fund budget" do
    visit finance_admin_fund_budgets_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @finance_admin_fund_budget.amount
    fill_in "Financial", with: @finance_admin_fund_budget.financial_id
    fill_in "Financial type", with: @finance_admin_fund_budget.financial_type
    fill_in "Note", with: @finance_admin_fund_budget.note
    click_on "Update Fund budget"

    assert_text "Fund budget was successfully updated"
    click_on "Back"
  end

  test "destroying a Fund budget" do
    visit finance_admin_fund_budgets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fund budget was successfully destroyed"
  end
end
