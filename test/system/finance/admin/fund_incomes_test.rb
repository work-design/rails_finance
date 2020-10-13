require "application_system_test_case"

class FundIncomesTest < ApplicationSystemTestCase
  setup do
    @finance_admin_fund_income = finance_admin_fund_incomes(:one)
  end

  test "visiting the index" do
    visit finance_admin_fund_incomes_url
    assert_selector "h1", text: "Fund Incomes"
  end

  test "creating a Fund income" do
    visit finance_admin_fund_incomes_url
    click_on "New Fund Income"

    fill_in "Amount", with: @finance_admin_fund_income.amount
    fill_in "Proof", with: @finance_admin_fund_income.proof
    fill_in "User", with: @finance_admin_fund_income.user_id
    click_on "Create Fund income"

    assert_text "Fund income was successfully created"
    click_on "Back"
  end

  test "updating a Fund income" do
    visit finance_admin_fund_incomes_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @finance_admin_fund_income.amount
    fill_in "Proof", with: @finance_admin_fund_income.proof
    fill_in "User", with: @finance_admin_fund_income.user_id
    click_on "Update Fund income"

    assert_text "Fund income was successfully updated"
    click_on "Back"
  end

  test "destroying a Fund income" do
    visit finance_admin_fund_incomes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fund income was successfully destroyed"
  end
end
